<p align="center">
  <img width="371" height="127" src="./logo.png">
</p>

![Licence Badge](https://badgen.net/badge/License/GPLv3.0/green)
![JS Style](https://badgen.net/badge/JS/Standard/yellow)
![CSS Style](https://badgen.net/badge/CSS/BEM/blue)
![Webpack](https://badgen.net/badge/webpack/v4/blue)
![Docker](https://badgen.net/badge/icon/docker-compose?icon=docker&label)

A reusable development environment for a 100% static website or template.

The website is just pure HTML5/CSS3 and Javascript. The final build is managed and created with Webpack4.
This repo gives a complete development environment for developers who want to construct a static website. All this stuff runs with makefiles command inside Docker containers. Moreover, we use webpack to bundle the website and webpack-dev-server to run a development server.

## Run the development environment

**requirements**: to run the environment, you need `docker` and `docker-compose` installed on your computer, if you don't have them follow the next links:
* [how to install docker](https://docs.docker.com/install/)
* [how to install docker-compose](https://docs.docker.com/compose/install/)

The first time you want to run the development environment, you need to build it and install his dependencies. For that, just run the command:

```shell
make init
```

Note: this command runs the environment in watch mode, so, a live reload is available in the browser when you update files.

If the environment was already initialized, just run the `watch` command to rerun it.

```shell
make watch
```

**The development server will be available on [localhost:9000](http://localhost:9000)**

Finally, when you want to stop the environment, run the `destroy` command:

```shell
make destroy
```

Note this command will stop the development environment but it doesn't destroy dependencies or configurations.

If you want to see all available commands to manipulate the development environment, just use `help` command:

```shell
make help
```

## Images management and bundling

Staticpack can manage and bundle your images (PNG, SVG and JP(E)G formats), follow this little guide to be able to add your images into HTML and CSS for bundling them.

### SVG management

The better way to use your SVG images or icons is to adding them to your HTML to let staticpack inlining them into the HTML.
Here is an example of inlining `img/github.svg`:

**src/index.html**
```html
<img inline src="./src/img/github.svg">
```

> Note: the plugin will watch for svg from the root of the project, so the valid path for your assets is `./src/img/`.

### Images management

For classic image import (PNG and JPG), you have to add templating to let staticpack resolve them when the bundle is created.

Here is an example of importing `img/example.png` into your HTML:

**src/index.html**
```html
<img src="<%= require('./img/example.png') %>" />
```

Finally, an example of importing `img/example.png` as a background image in a CSS stylesheet:

**src/css/main.css**
```css
.rule {
  background-image: url('~../img/example.png');
}
```

## HTML template management and bundling

Each page of the website is managed like an html template, to be able to include one bundled JS script and CSS stylesheet.

To add a new HTML page, just copy/paste the existing `index.html` and rename it.
For example to create a `404.html page`:

```shell
cp ./index.html 404.html
```

> **Note**: don't forget to update the content of the template like the title or meta tags.

Now, create an associated JS script for your new page:

```shell
touch 404-script.js
```

Finally, to add your page and script to your bundle, update the `webpack.comon.js`:

```js
// webpack v4
// comon configuration between development and production bundle.

// ... all imports

module.exports = {
  entry: { 
    main: './src/js/index.js',
    scriptJs404: './src/404-script.js'
  },
  // ...
  plugins: [
    // ...
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'src/index.html',
      chunks: ['main']
    }),
    new HtmlWebpackPlugin({
      filename: '404.html',
      template: 'src/404.html',
      chunks: ['scriptJs404']
    }),
    // ...
  ]
}
```

> **Note**: we use the `chunks` option to associate one specific JS script for each HTML page of the website.

## Test the website in production mode

Webpack can bundle your website for production with some optimization, to be sure the website work in this mode you can run the command:

```shell
make run
```

**A server will be available on [localhost:3000](http://localhost:3000)**

## Create a production ready archive

To build, package an optimized bundle for production just used the `package` command.

```shell
make package
```

a `website.zip` will be created into the root folder of your development environment. This archive contains all the assets you need and is ready to be unzipped into your `www` folder in production.

If you want to clean your development environment and delete the `dist` folder and the `website.zip` just use the following command:

```shell
make clean
```

## Deploy the website with terraform

You can automatically deploy the production bundle to a bucket on Google Cloud Platform.
After the configuration of your GCP environment (project, service account, credentials key, and IAM), and the configs.env file, just launch the command:

```shell
make gcp-deploy
```
> **Note:** you can follow [this guide](./deploy/gcp/guide/deployment-configuration.md) to configure the GCP environment and the configs.env before launching the local deployment.
