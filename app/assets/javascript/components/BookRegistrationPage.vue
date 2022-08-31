<template>
  <a-typography-title :level="2">図書登録</a-typography-title>
  <a-card>
    <a-form
      ref="formRef"
      name="bookRegistration"
      hide-required-mark="true"
      :model="formState"
      :rules="rules"
      v-bind="layout"
      @validate="handleValidate"
      @submit.prevent="onSubmit"
    >

      <a-form-item
        has-feedback
        label="タイトル"
        name="title"
      >
        <a-input v-model:value="formState.title" autocomplete="off" />
      </a-form-item>

      <a-form-item
        has-feedback
        label="著者"
        name="author_id"
      >
        <a-select v-model:value="formState.author_id" :options="authors">
        </a-select>
      </a-form-item>

      <a-form-item
        has-feedback
        label="カテゴリー"
        name="category_id"
      >
        <a-select v-model:value="formState.category_id" :options="categories">
        </a-select>
      </a-form-item>

      <a-form-item :wrapper-col="{ offset: 8, span: 8 }">
        <a-button type="primary" html-type="submit" :disabled="!formState.validate">登録する</a-button>
      </a-form-item>

    </a-form>
  </a-card>
</template>
<script>
import { defineComponent, reactive, ref } from 'vue'
import axios from 'axios';
import { message } from 'ant-design-vue';

export default defineComponent({
  name: "registerBook",
  setup() {
    const formRef = ref();
    const formState = reactive({
      title: '',
      author_id: '',
      category_id: '',
      validate: false
    });

    const categories = reactive([]);

    // カテゴリを取得する
    categories.push({value: 1,label: "英語"},
                    {value: 2,label: "数学"},
                    {value: 3,label: "物理"},
                    {value: 4,label: "化学"},
                    {value: 5,label: "生物"},
                    {value: 6,label: "その他"})

    const authors = reactive([]);

    let validStatus = {
      title: false,
      author_id: false,
      category_id: false
    };

    // 著者を取得する
    axios
      .get('/api/v1/authors/')
      .then(function (response) {
        console.log(response.data);
        response.data.authors.forEach(function(author) {
          authors.push({
            value: author.id,
            label: author.name
          })
        });
      });

    let validateTitle = async (_rules, value) => {
      if (!value) {
        return Promise.reject('タイトルを入力してください。');
      }
      return Promise.resolve();
    };

    let validateAuthorId = async (_rules, value) => {
      if (!value) {
        return Promise.reject('著者を選択してください。');
      }
      return Promise.resolve();
    };

    let validateCategoryId = async (_rules, value) => {
      if (!value) {
        return Promise.reject('カテゴリを選択してください。');
      }
      return Promise.resolve();
    };

    const rules = {
      title: [{
        required: true,
        validator: validateTitle,
        trigger: 'change',
      }],
      author_id: [{
        required: true,
        validator: validateAuthorId,
        trigger: 'change',
      }],
      category_id: [{
        required: true,
        validator: validateCategoryId,
        trigger: 'change',
      }],
    };

    const layout = {
      labelCol: {
        span: 8
      },
      wrapperCol: {
        span: 8
      }
    };

    const handleValidate = (name, status, errorMessage) => {
      updateValidate(name, status);
    };

    let updateValidate = (name, status) => {
      validStatus[name] = status;

      formState.validate = true;
      for (let key in validStatus) {
        formState.validate &&= validStatus[key];
      }
    };

    let initValidate = () => {
      for (let key in validStatus) {
        validStatus[key] = false;
      }
      formState.validate = false;
    }

    const onSubmit = () => {
      console.log('book title:', formState.title);
      console.log('author id:', formState.author_id);
      axios
        .post('/api/v1/books',{
          title: formState.title,
          author_id: formState.author_id,
          category_id: formState.category_id
        })
        .then(function (response) {
          console.log(response.data);
          formRef.value.resetFields();
          initValidate();
          message.success('図書の登録が完了しました。', 3);
        });
    };

    return {
      formRef,
      formState,
      rules,
      layout,
      handleValidate,
      authors,
      categories,
      onSubmit,
    }
  }
})
</script>
