<template>
  <h1>著者登録</h1>

  <div class="input-form">
    <form @submit.prevent="onSubmit">
      <div class="field">
        <label>著者名</label>
        <input v-model="state.name" type="text">
        <p v-if="!!state.errors['name']" class="error" style="color: red;">{{ state.errors['name'][0]}}</p>
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
    const state = reactive({ name: '', errors: '' });

    const onSubmit = () => {
      console.log('author name:', state.name);
      axios
        .post('/api/v1/authors',{
          name: state.name
        })
        .then(function (response) {
          console.log(response.data);
        })
        .catch(error => {
          if (error.response.data && error.response.data.errors) {
            state.errors = error.response.data.errors;
          }
        });
    }

    return {
      state,
      onSubmit
    }
  }
})
</script>
