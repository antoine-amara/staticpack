// webpack v4
// specific rules to build development bundle.

const { merge } = require('webpack-merge')
const common = require('./webpack.common')

const { HotModuleReplacementPlugin } = require('webpack')

module.exports = merge(common, {
  mode: 'development',
  devtool: 'inline-source-map',
  plugins: [
    new HotModuleReplacementPlugin({})
  ],
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
