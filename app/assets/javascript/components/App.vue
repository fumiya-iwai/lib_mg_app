<template>
  <a-layout id="app-layout" style="background: #fff; min-width: 900px;">
    <a-layout-header style="background: #fff">
      <a-row type="flex">
        <a-col >
          <img src="~logo.svg" width="165">
        </a-col>
        <a-col flex="auto" justify="end">
          <a-row type="flex" justify="end">
            <a-col>
              <a-menu v-model:selectedKeys="current"
                      mode="horizontal" style="border: 0">
                <a-menu-item v-for="item in itemList" :key="item.name">
                  <router-link :to="{ name: item.name }">{{ item.content }}</router-link>
                </a-menu-item>
              </a-menu>
            </a-col>
          </a-row>
        </a-col>
        <a-col>
          <span>{{ state.point }} PT</span>
        </a-col>
        <a-col justify="end" style="margin-left: 24px">
          <a-dropdown trigger="['click']">
            <img src="~user.svg" width="40" style="cursor: pointer">
            <template #overlay>
              <a-menu>
              <a-menu-item>
                <a href="/#/rentals">
                    貸出し中
                  </a>
                </a-menu-item>
              <a-menu-item>
                <a href="/logout">
                    ログアウト
                  </a>
                </a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>
        </a-col>
      </a-row>
    </a-layout-header>
    <a-divider style="height: 1px; background-color: #F0F0F0; margin: 0"/>

    <a-layout-content style="padding: 50px;">
      <router-view/>
    </a-layout-content>
  </a-layout>
  
</template>

<script>
import { defineComponent, ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios';
import { message } from 'ant-design-vue';
// 著者を取得する
import 'logo.svg';
import 'user.svg';

export default defineComponent({
  setup () {
    const itemList = [
      { name: 'books', content: '図書一覧' },
      { name: 'book', content: '図書登録' },
      { name: 'author', content: '著者登録' }
    ]
    const current = ref([])
    const router = useRouter();
    router.afterEach((to) => {
      current.value[0] = to.name;
    });
//変数定義
    const state = reactive({
      point: 0
    });
    const userPoint = () => {
      axios
        .get('/api/v1/users/point')
        .then(function (response) {
          console.log(response.data);
          state.point = response.data.point;
        });
    }
    userPoint();
//フロントへ反映
    return {
      current,
      itemList,
      state
    };
  },
})
</script>