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

## Test the website in production mode

Webpack can bundle your website for production with some optimization, to be sure the website work in this mode you can run the command:

```shell
make run
```

**A server will be available on [localhost:3000](http://localhost:3000)**

## Create a production ready archive

To build and package an optimized bundle for production just used the `package` command.

```shell
make package
```

a `website.zip` will be created into the root folder of your development environment. This archive contains all the assets you need and is ready to be unzipped into your `www` folder in production.

If you want to clean your development environment and delete the `dist` folder and the `website.zip` just use the following command:

```shell
make clean
```
