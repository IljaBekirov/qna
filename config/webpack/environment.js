const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

const HandlebarsLoader = {
  test: /\.hbs$/,
  loader: 'handlebars-loader'
}
environment.loaders.append('hbs', HandlebarsLoader)

module.exports = environment
