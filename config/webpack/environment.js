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
    __VUE_OPTIONS_API__:   false, // 古い書き方である OPTIONS API は使えないようにする
    __VUE_PROD_DEVTOOLS__: false,
  })
)

module.exports = environment
