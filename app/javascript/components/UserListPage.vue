<template>
  <h1>UserListPage</h1>

  <ul>
    <li v-for="user in state.users" :key="user.id">
      {{ user.last_name }} {{ user.first_name }}
    </li>
  </ul>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  setup () {
    const state = reactive({ users: [] });

    axios
        .get('/api/v1/users/')
        .then(response => (state.users = response.data))

    return {
      state,
    }
  }
})
</script>
