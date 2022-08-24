<template>
  <a-typography-title :level="2">著者登録</a-typography-title>

  <a-card>
    <a-form
      ref="formRef"
      name="authorRegistration"
      hide-required-mark="true"
      :model="formState"
      :rules="rules"
      v-bind="layout"
      @validate="handleValidate"
      @submit="onSubmit"
    >
      <a-form-item
        has-feedback
        label="著者名"
        name="name"
      >
        <a-input v-model:value="formState.name" autocomplete="off" />
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
  name: "registerAuthor",
  setup() {
    const formRef = ref();
    const formState = reactive({
      name: '',
      validate: false
    });

    let validateName = async (_rules, value) => {
      if (!value) {
        return Promise.reject('著者名を入力してください。');
      }
      return Promise.resolve();
    }

    const rules = {
      name: [{
        required: true,
        validator: validateName,
        trigger: 'change',
      }]
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
      formState.validate = status;
    };

    const onSubmit = () => {
      console.log('author name:', formState.name);
      axios
        .post('/api/v1/authors',{
          name: formState.name
        })
        .then(function (response) {
          console.log(response.data);
          formRef.value.resetFields();
          formState.validate = false;
          message.success('著者の登録が完了しました。', 3);
        });
    }

    return {
      formRef,
      formState,
      rules,
      layout,
      handleValidate,
      onSubmit,
    }
  }
})
</script>
