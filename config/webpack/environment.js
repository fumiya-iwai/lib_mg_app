const { environment } = require('@rails/webpacker')
const { DefinePlugin } = require('webpack')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

// コンパイルを高速化するため
environment.splitChunks()

environment.plugins.prepend(
  'Define',
  new DefinePlugin({
    __VUE_OPTIONS_API__:   true, // ant-design の内部で OPTIONS API を使っているため
    __VUE_PROD_DEVTOOLS__: false,
  })
)

module.exports = environment
