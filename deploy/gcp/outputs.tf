# website bucket outputs infos
output "website_domain_name" {
  value       = google_storage_bucket.website_bucket.name
  description = "the website domain name (it is the bucket name too)."
}

# website network configurations outputs
output "website_ip" {
  value       = google_compute_global_address.website_external_ip.address
  description = "the website external IP"
}

output "website_configurations" {
  value       = google_storage_bucket.website_bucket.website
  description = "website index and 404 error file configuration"
}
