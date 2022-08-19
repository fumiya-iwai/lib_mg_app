<template>

  <a-row type="flex" justify="space-between">
    <a-typography-title :level="2">図書一覧</a-typography-title>
    <a-input-search
      v-model:value="state.searchText"
      placeholder="キーワードで検索"
      enter-button
      @search="search(state.searchText, 1)"
      style="width: 300px"
    />
  </a-row>

<!--  <a-table :dataSource="state.books" :columns="columns" rowKey="id" :row-selection="{ selectedRowKeys: state.selectedBookIds, onChange: onSelectChange }" :pagination="pagination" />-->
  <a-table :dataSource="state.books" :columns="columns" rowKey="id" :row-selection="{ selectedRowKeys: state.selectedBookIds, onChange: onSelectChange }" :pagination="false"/>

  <a-row type="flex" justify="space-between" style="margin: 20px">
    <a-pagination :total="state.totalBooks" @change="changePage" :hideOnSinglePage="true"/>
    <a-button type="primary" @click="rentBooks()" :disabled="state.selectedBookIds.length === 0">借りる</a-button>
  </a-row>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "book list",
  setup(_props) {
    const ROWS_PER_PAGE = 10; // 1ページあたりの表示行数
    const state = reactive({
      books: [],
      totalBooks: 0,
      searchText: '',
      selectedBookIds: [] ,
      allChecked: false
    });
    let lastSearchText = ''; // ページング時はテキストボックスの内容に依らず検索させるため、別に保持させる
    const columns = [
      {
        title: 'タイトル',
        dataIndex: 'title',
        key: 'title',
      },
      {
        title: '著者',
        dataIndex: 'author_name',
        key: 'authorName',
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
          lastSearchText = searchText;
          // 検索後はチェックボックスの選択状態を初期化する
          state.allChecked = false;
          state.selectedBookIds = [];
        })
    }

    const rentBooks = () => {
      axios
        .post('/api/v1/rentals/',{
          book_ids: state.selectedBookIds.join(','),
        })
        .then(function () {
          search(lastSearchText);
        })
    }

    const changePage = (page) => {
      search(lastSearchText, page);
    };

    const onSelectChange = (selectedRowKeys) => {
      state.selectedBookIds = selectedRowKeys;
    };

    // const pagination =  reactive({
    //   position: ['bottomLeft'],
    //   total: state.totalBooks,
    //   change: changePage,
    //   hideOnSinglePage: true
    // });

    // 初期リスト作成
    search();

    return {
      state,
      rentBooks,
      search,
      changePage,
      columns,
      onSelectChange,
      // pagination,
    }
  }
})
</script>
