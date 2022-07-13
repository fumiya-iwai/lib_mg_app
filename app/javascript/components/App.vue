<template>
  <p>{{ message }}</p>

  <div id="nav">
    <router-link to="/">HomePage</router-link> |
    <router-link to="/users">UserListPage</router-link> |
    <router-link to="/users/register">UserRegisterPage</router-link>
  </div>
  <router-view/>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  setup () {
    return {
      message: "Hello Vue!"
    }
  }
})
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
