<template>
  <a-layout id="app-layout" style="height: 100%; background: #fff; min-width: 900px;">
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
      </a-row>
    </a-layout-header>
    <a-divider style="height: 1px; background-color: #F0F0F0; margin: 0"/>

    <a-layout-content style="padding: 50px;">
      <router-view/>
    </a-layout-content>
  </a-layout>
</template>

<script>
import { defineComponent, ref } from 'vue'
import { useRouter } from 'vue-router'
import 'logo.svg';

export default defineComponent({
  setup () {
    const itemList = [
      { name: 'books', content: '図書一覧' },
      { name: 'rentals', content: '貸出' },
      { name: 'book', content: '図書登録' },
      { name: 'author', content: '著者登録' },
    ]
    const current = ref([])
    const router = useRouter();
    router.afterEach((to) => {
      current.value[0] = to.name;
    });

    return {
      current,
      itemList,
    };
  },
})
</script>
