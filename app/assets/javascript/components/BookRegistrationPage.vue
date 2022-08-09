<template>
  <h1>図書登録</h1>
  <div class="input-form">
    <form @submit.prevent="onSubmit">
      <div class="field">
        <label>タイトル</label>
        <input v-model="state.title" @input="validateBookTitle" type="text">
        <p v-if="!!state.errors['title']" class="error" style="color: red;">{{ state.errors['title'].join("\n")}}</p>
      </div>
      <div class="field">
        <label>著者</label>
        <select v-model="state.author_id" @change="validateAuthor">
          <option v-for="author in state.authors" :value="author.id" :key="author.id">{{author.name}}</option>
        </select>
        <p v-if="!!state.errors['author']" class="error" style="color: red;">{{ state.errors['author'].join("\n")}}</p>
      </div>
      <button type="submit" :disabled="state.validate === false">登録する</button>
    </form>
  </div>
</template>
<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "register book",
  setup(_props) {
    const state = reactive({ title: '', authors: [], author_id: 0, validate: false, errors: {} });

    axios
      .get('/api/v1/authors/')
      .then(function (response) {
        console.log(response.data);
        state.authors = response.data.authors
      })

    const onSubmit = () => {
      console.log('book title:', state.title);
      console.log('author id:', state.author_id);
      axios
        .post('/api/v1/books',{
          title: state.title,
          author_id: state.author_id
        })
        .then(function (response) {
          console.log(response.data);
          state.title = '';
          state.author_id = 0;
          // todo: 「登録しました」のメッセージを出したい
        })
        .catch(error => {
          if (error.response.data && error.response.data.errors) {
            state.errors = error.response.data.errors;
          }
        });
    };

    const updateValidate = () => {
      state.validate = (state.title.length > 0 && state.author_id > 0);
    };

    const validateBookTitle = () => {
      state.errors['title'] = (state.title.length > 0) ? [] : ["タイトルを入力してください。"];
      updateValidate();
    };

    const validateAuthor = () => {
      state.errors['author'] = (state.author_id > 0) ? [] : ["著者を選択してください。"];
      updateValidate();
    };

    return {
      state,
      onSubmit,
      validateBookTitle,
      validateAuthor
    }
  }
})
</script>
