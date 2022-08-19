<template>
  <h1>図書一覧</h1>
  <div>
    <input v-model="state.searchText" type="text">
    <button @click="search(state.searchText, 1)">検索！</button>
  </div>
  <div>
    <div  style="height: 620px">
<!--      <a-table :dataSource="state.books" :columns="columns" rowKey="id" :row-selection="{ selectedRowKeys: state.selectedBookIds, onChange: onSelectChange }" :pagination="pagination" />-->
      <a-table :dataSource="state.books" :columns="columns" rowKey="id" :row-selection="{ selectedRowKeys: state.selectedBookIds, onChange: onSelectChange }" :pagination="false"/>
    </div>
    <div>
      <a-pagination :total="state.totalBooks" @change="changePage" :hideOnSinglePage="true"/>
    </div>
    <div>
      <button @click="rentBooks()">借りる</button>
    </div>
  </div>
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
