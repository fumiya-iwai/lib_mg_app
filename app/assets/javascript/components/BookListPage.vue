<template>

  <a-row type="flex" justify="space-between">
    <a-col>
      <a-typography-title :level="2">図書一覧</a-typography-title>
    </a-col>
    <a-col>
      <a-input-search
        v-model:value="state.searchText"
        placeholder="キーワードで検索"
        enter-button
        @search="search(state.searchText, 1)"
      />
    </a-col>
  </a-row>

  <!-- a-table に自動で付与されるページネーション機能だと、全件を取得した前提でのページネーションとなる -->
  <!-- ページネーション毎にAPIにアクセスする仕様に向いていないため、:pagination="false" とし、別に a-pagination を定義する -->
  <a-table
    :dataSource="state.books"
    :columns="columns"
    rowKey="id"
    :row-selection="{ selectedRowKeys: state.selectedBookIds, onChange: onSelectChange }"
    :pagination="false"/>

  <a-row type="flex" justify="space-between" style="height: 100px; padding-top: 20px;">
    <a-col>
      <a-pagination :total="state.totalBooks" @change="changePage" :hideOnSinglePage="true"/>
    </a-col>
    <a-col>
      <a-button type="primary" @click="rentBooks()" :disabled="state.selectedBookIds.length === 0">
        借りる
      </a-button>
    </a-col>
  </a-row>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';
import { message } from 'ant-design-vue';

export default defineComponent({
  name: "book list",
  setup(_props) {
    const ROWS_PER_PAGE = 10; // 1ページあたりの表示行数
    const state = reactive({
      books: [],
      totalBooks: 0,
      searchText: '',
      selectedBookIds: [] ,
    });
    let lastSearchText = ''; // ページング時はテキストボックスの内容に依らず検索させるため、別に保持させる
    const columns = [
      {
        title: 'タイトル',
        dataIndex: 'title',
      },
      {
        title: '著者',
        dataIndex: 'author_name',
        width: '200px',
      },
    ];

    const search = (searchText, page = 1) => {
      let offset = (page - 1) * ROWS_PER_PAGE
      axios
        .get('/api/v1/books/',{
          params: {
            search_text: searchText,
            rentable: true,
            limit: ROWS_PER_PAGE,
            offset: offset,
          },
        })
        .then(function (response) {
          state.books = response.data.data;
          state.totalBooks = response.data.count;
          // テキストボックスが変更された状態でページネーションされた場合を考慮し、
          // 検索処理で使用された条件に上書きしておく
          state.SearchText = searchText;
          lastSearchText = searchText;
          // 検索後はチェックボックスの選択状態を初期化する（ページを跨いで選択させない）
          state.selectedBookIds = [];
        })
    }

    const rentBooks = () => {
      axios
        .post('/api/v1/rentals/',{
          book_ids: state.selectedBookIds.join(','),
        })
        .then(function () {
          message.success(`${state.selectedBookIds.length}冊の本を借りました。`, 3);
          search(lastSearchText, 1);
        })
        .catch(function (error) {
          message.error(error.response.data.error, 3)
        })
    }

    const changePage = (page) => {
      search(lastSearchText, page);
    };

    const onSelectChange = (selectedRowKeys) => {
      state.selectedBookIds = selectedRowKeys;
    };

    // 初期リスト作成
    search('', 1);

    return {
      state,
      columns,
      search,
      rentBooks,
      changePage,
      onSelectChange,
    }
  }
})
</script>
