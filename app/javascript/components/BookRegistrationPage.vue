<template>
  <h1>図書登録</h1>
  <div class="input-form">
    <form @submit.prevent="onSubmit">
      <div class="field">
        <label>タイトル</label>
        <input v-model="state.title" type="text">
      </div>
      <div class="field">
        <label>著者</label>
        <select name="author_id">
          <option v-for="author in state.authors" v-bind:value="author.id">{{author.name}}</option>
        </select>
      </div>
      <button type="submit">登録する</button>
    </form>
  </div>
</template>
<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "register book",
  setup(_props) {
    const state = reactive({ title: '', authors: [] });

    axios
      .get('/api/v1/authors/')
      .then(function (response) {
        console.log(response.data);
        state.authors = response.data.authors
      })

    const onSubmit = () => {
      console.log('book title:', state.title);
      axios
        .post('/api/v1/books',{
          title: state.title,
          author_id: 1
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
