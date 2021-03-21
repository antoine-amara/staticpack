provider "google" {
  project     = var.gcp_project_id
  credentials = file(var.authkey)
  region      = "europe-west2"
}

##########
# create and configure access to a bucket
# containing the static website

# create the website bucket
resource "google_storage_bucket" "website_bucket" {
  name     = var.domain
  location = "EU"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  force_destroy = true
}

# manage website bucket access
# make it public
resource "google_storage_default_object_access_control" "website_public_access" {
  bucket = google_storage_bucket.website_bucket.name
  role   = "READER"
  entity = "allUsers"
}

# configure the website bucket as a CDN
resource "google_compute_backend_bucket" "website_cdn" {
  provider    = google
  name        = "website-backend"
  description = "Contains files needed by the website"
  bucket_name = google_storage_bucket.website_bucket.name
  enable_cdn  = true
}

##########

##########
# upload website to bucket

resource "null_resource" "upload_website_to_bucket" {

  triggers = {

    file_hashes = jsonencode({

      for fn in fileset(var.dist_path, "**") :

      fn => filesha256("${var.dist_path}/${fn}")

    })

  }

  provisioner "local-exec" {
    command = "gcloud auth activate-service-account --key-file ${var.authkey}"
  }

  provisioner "local-exec" {

    command = "gsutil cp -r ${var.dist_path}* gs://${google_storage_bucket.website_bucket.name}/"

  }

  depends_on = [google_storage_bucket.website_bucket]

}

##########

##########
# reserve an external IP for the website

resource "google_compute_global_address" "website_external_ip" {
  provider = google
  name     = "website-lb-ip"
}

##########

##########
# DNS configurations

# create a DNS zone
resource "google_dns_managed_zone" "dns_zone" {
  name        = var.gcp_project_id
  dns_name    = "${var.domain}."
  description = "website domain DNS zone"

  visibility = "public"
}

# create an A record for the root domain
resource "google_dns_record_set" "website_dns_record_a_root" {
  provider     = google
  name         = "${var.domain}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_global_address.website_external_ip.address]
}

##########

# create an A record for the www sub-domain
resource "google_dns_record_set" "website_dns_record_a_www" {
  provider     = google
  name         = "www.${var.domain}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_global_address.website_external_ip.address]
}

##########

##########
# create and configure a reverse proxy

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "website_https_certificate" {
  provider = google
  name     = "website-cert"
  managed {
    domains = [google_dns_record_set.website_dns_record_a_root.name, google_dns_record_set.website_dns_record_a_www.name]
  }
}

# create the HTTPS proxy
resource "google_compute_target_https_proxy" "website_https_proxy" {
  provider         = google
  name             = "website-target-proxy"
  url_map          = google_compute_url_map.website_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website_https_certificate.self_link]
}

# forwarding rule: link the ip to the reverse proxy
resource "google_compute_global_forwarding_rule" "website_default_forwarding" {
  provider              = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website_external_ip.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website_https_proxy.self_link
}

# URL MAP: link the reverse proxy to the CDN / Bucket
resource "google_compute_url_map" "website_url_map" {
  provider        = google
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.website_cdn.self_link
}

##########

##########
# create the http proxy to redirect to https

# create HTTP reverse proxy
resource "google_compute_target_http_proxy" "website_http_proxy" {
  provider = google
  name     = "web-map-http"
  url_map  = google_compute_url_map.http_to_https_url_map.self_link
}

# forwarding rule: link http traffic to the http proxy
resource "google_compute_global_forwarding_rule" "website_http_forwarding" {
  provider              = google
  name                  = "http-content-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website_external_ip.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.website_http_proxy.self_link
}

# URL MAP: create http tp https redirection with HTTP 301 response code
resource "google_compute_url_map" "http_to_https_url_map" {
  provider = google
  name     = "web-url-map-http"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
##########
