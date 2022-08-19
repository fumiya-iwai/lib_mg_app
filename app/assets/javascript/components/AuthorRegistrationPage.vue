<template>
  <a-typography-title :level="2">著者登録</a-typography-title>

  <a-card>
    <a-form
      :model="formState"
      name="author"
      :label-col="{ span: 8 }"
      :wrapper-col="{ span: 8 }"
      @submit.prevent="onSubmit"
    >
      <a-form-item
        label="著者名"
        name="name"
        :rules="[{ required: true, message: '著者名を入力してください。'}]"
      >
        <a-input v-model:value="formState.name" @input="validateAuthorName" />
<!--        <p v-if="!!formState.errors['name']" class="error" style="color: red;">{{ formState.errors['name'].join("\n") }}</p>-->
      </a-form-item>

      <a-form-item :wrapper-col="{ offset: 8, span: 16 }">
        <a-button type="primary" html-type="submit" :disabled="formState.validate === false">登録する</a-button>
      </a-form-item>
    </a-form>
  </a-card>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "register author",
  setup(_props) {
    const formState = reactive({
      name: '',
      validate: false,
      errors: {}
    });

    const onSubmit = () => {
      console.log('author name:', formState.name);
      axios
        .post('/api/v1/authors',{
          name: formState.name
        })
        .then(function (response) {
          console.log(response.data);
          formState.name = '';
          // todo: 「登録しました」のメッセージを出したい
        })
        .catch(error => {
          if (error.response.data && error.response.data.errors) {
            formState.errors = error.response.data.errors;
          }
        });
    }

    const validateAuthorName = () => {
      formState.errors = (formState.name.length > 0) ? {} : { name: ["著者名を入力してください。"] };
      formState.validate = (formState.name.length > 0);
    }

    return {
      formState,
      onSubmit,
      validateAuthorName
    }
  }
})
</script>
