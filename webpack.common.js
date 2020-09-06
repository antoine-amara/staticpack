// webpack v4
// comon configuration between development and production bundle.

const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const HtmlWebpackInlineSVGPlugin = require('html-webpack-inline-svg-plugin')

module.exports = {
  entry: { main: './src/js/index.js' },
  output: {
    path: path.resolve(process.cwd(), 'dist'),
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
          {
            loader: MiniCssExtractPlugin.loader
          },
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              config: {
                path: path.resolve(process.cwd(), 'postcss.config.js')
              }
            }
          }
        ]
      },
      {
        test: /\.(png|jp(e*)g|svg)$/,
        use: [{
          loader: 'url-loader',
          options: {
            limit: 8192, // Convert images < 8kb to base64 strings
            name: '[hash]-[name].[ext]',
            outputPath: 'img',
            esModule: false
          }
        }]
      },
      {
        test: /\.(ttf|eot|woff|woff2)$/,
        use: [
          {
            loader: 'file-loader'
          }
        ]
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: '[name].[contenthash].css'
    }),
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'src/index.html',
      chunks: ['main']
    }),
    new HtmlWebpackInlineSVGPlugin({
      runPreEmit: true
    }),
    new CopyWebpackPlugin({
      patterns: [
        { from: './src/browserconfig.xml', to: './' },
        { from: './src/favicon.ico', to: './' },
        { from: './src/humans.txt', to: './' },
        { from: './src/icon.png', to: './' },
        { from: './src/robots.txt', to: './' },
        { from: './src/site.webmanifest', to: './' },
        { from: './src/tile-wide.png', to: './' },
        { from: './src/tile.png', to: './' }
      ]
    })
  ]
}
