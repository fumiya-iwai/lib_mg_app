import axios from 'axios';
import { message } from 'ant-design-vue';

axios.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response.status === 400) {
      if (Array.isArray(error.response.data.error)) {
        var errors = error.response.data.error;
        errors.forEach((err) => {
          message.error(err);
        });
      } else if (typeof error.response.data.error === 'string') {
        message.error(error.response.data.error);
      } else {
        message.error('エラーが発生しました。');
      }
    } else if (error.response.status === 401) {
      message.error('ログインしてください');
    } else if (error.response.status === 403) {
      message.error('この機能を利用する権限がありません');
    } else if (error.response.status === 404) {
      message.error('リクエスト先が存在しません');
    } else if (error.response.status === 500) {
      message.error('サーバーエラーが発生しました');
    }
    return Promise.reject(error);
  }
);
