// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// 切り分けが面倒なため Rails 既存機能には依存しないようにする
// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
// import "channels"
//
// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()

import { createApp } from 'vue'
import App from '../components/App.vue'
import router from '../config/router'
import Antd from 'ant-design-vue'
import 'ant-design-vue/dist/antd.css'

document.addEventListener('DOMContentLoaded', () => {
  createApp(App).use(router).use(Antd).mount('#app')
})
