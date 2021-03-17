// webpack v5
// specific rules to build development bundle.

const { merge } = require('webpack-merge')
const common = require('./webpack.common')


module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  target: 'web',
  devServer: {
    host: '0.0.0.0',
    port: 9000,
    hot: true,
    overlay: true,
    contentBase: [
      './src/',
      './src/css/',
      './src/js/'
    ],
    watchContentBase: true
  }
})
