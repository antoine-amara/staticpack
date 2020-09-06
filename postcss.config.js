module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-preset-env'),
    require('cssnano'),
    require('postcss-reporter')({ clearReportedMessages: true })
  ]
}
