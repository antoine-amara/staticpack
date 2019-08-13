// webpack v4

const path = require('path')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const { HotModuleReplacementPlugin } = require('webpack')

module.exports = {
  entry: { main: './src/js/index.js' },
  devtool: 'inline-source-map',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[hash].js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [
          'style-loader',
          {
            loader: MiniCssExtractPlugin.loader
          },
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              config: {
                path: path.resolve(__dirname, 'postcss.config.js')
              }
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin({
      cleanOnceBeforeBuildPatterns: ['./dist/**/*']
    }),
    new MiniCssExtractPlugin({
      filename: '[name].[contenthash].css'
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    }),
    new CopyWebpackPlugin([
      { from: './src/browserconfig.xml', to: './' },
      { from: './src/favicon.ico', to: './' },
      { from: './src/humans.txt', to: './' },
      { from: './src/icon.png', to: './' },
      { from: './src/robots.txt', to: './' },
      { from: './src/site.webmanifest', to: './' },
      { from: './src/tile-wide.png', to: './' },
      { from: './src/tile.png', to: './' }
    ]),
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
}
