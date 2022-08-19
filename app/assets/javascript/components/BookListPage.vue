<template>
  <h1>図書一覧</h1>
  <div>
    <input v-model="state.searchText" type="text">
    <button @click="search(state.searchText, 1)">検索！</button>
  </div>
  <div>
    <div  style="height: 300px">
      <table>
        <tr>
          <th><input type="checkbox" @change="allChange()" v-model="state.allChecked"></th>
          <th>タイトル</th>
          <th>著者</th>
        </tr>
        <tr v-for="book in state.books" >
          <td><input type="checkbox" :value="book.id" v-model="state.selectedBookIds" ></td>
          <td>{{ book.title }}</td>
          <td>{{ book.author_name }}</td>
        </tr>
      </table>
    </div>
    <div>
      <a-pagination :total="state.totalBooks" @change="changePage" :hideOnSinglePage="true"/>
    </div>
    <div>
      <button @click="rentBooks()">借りる</button>
    </div>
  </div>
</template>

<style>
table {
  border-collapse: collapse;
}
th, td {
  border: 1px solid #333;
}
</style>

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
        .post('/api/v1/rentals',{
          book_ids: state.selectedBookIds.join(','),
        })
        .then(function () {
          search(lastSearchText);
        })
    }

    const changePage = (page) => {
      search(lastSearchText, page);
    };

    const allChange = () => {
      if (state.allChecked) {
        state.selectedBookIds = state.books.map(book => book.id);
      } else {
        state.selectedBookIds = [];
      }
    }

    // 初期リスト作成
    search();

    return {
      state,
      rentBooks,
      search,
      changePage,
      allChange,
    }
  }
})
</script>
