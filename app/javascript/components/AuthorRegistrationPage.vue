<template>
  <h1>著者登録</h1>

  <div class="input-form">
    <form @submit.prevent="onSubmit">
      <div class="field">
        <label>著者名</label>
        <input v-model="state.name" type="text">
      </div>
      <button type="submit">登録する</button>
    </form>
  </div>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "register author",
  setup(_props) {
    const state = reactive({ name: '' });

    const onSubmit = () => {
      console.log('author name:', state.name);
      axios
        .post('/api/v1/authors',{
          name: state.name
        })
        .then(function (response) {
          console.log(response.data);
        })
    }

    return {
      state,
      onSubmit
    }
  }
})
</script>
