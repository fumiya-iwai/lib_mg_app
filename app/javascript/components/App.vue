<template>
  <header>
    <div id="nav">
      <router-link to="/books">図書一覧</router-link> |
      <router-link to="/rentals">貸出</router-link> |
      <router-link to="/books/new">図書登録</router-link> |
      <router-link to="/authors/new">著者登録</router-link>
    </div>
  </header>

  <router-view/>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  setup () {
    return {
    }
  }
})
</script>

<style scoped>
</style>
