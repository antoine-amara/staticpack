module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-reporter')({ clearReportedMessages: true })
  ]
}
