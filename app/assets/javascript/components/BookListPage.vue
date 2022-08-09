<template>
  <h1>図書一覧</h1>
  <div>
    <input v-model="state.searchText" type="text">
    <button @click="search(state.searchText, 1)">検索！</button>
  </div>
  <div>
    <div  style="height:250px">
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
    <div style="display: flex; flex-direction: row;">
      <div style="margin-right: 3px;"><button :disabled="state.currentPage === 1" @click="search(state.lastSearchText, state.currentPage - 1)">＜</button></div>
      <div style="margin-right: 3px;" v-for="n in state.maxPage">
        <button :disabled="state.currentPage === n" @click="search(state.lastSearchText, n)">
          {{ n }}
        </button>
      </div>
      <div style="margin-right: 3px;"><button :disabled="state.currentPage === state.maxPage" @click="search(state.lastSearchText, state.currentPage + 1)">＞</button></div>
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
    const state = reactive({ books: [], currentPage: 1, maxPage: 1, searchText: '', lastSearchText: '', selectedBookIds: [] ,allChecked: false}); // TODO: 型定義とかしておくべき？
    const ROWS_PER_PAGE = 8;

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
          state.allChecked = false;
          state.selectedBookIds = [];
          state.lastSearchText = searchText;
          state.currentPage = page;
          state.books = response.data.data;
          state.maxPage = Math.floor(response.data.count / ROWS_PER_PAGE) + 1;
        })
    }

    const rentBooks = () => {
      axios
        .post('/api/v1/rentals',{
          book_ids: state.selectedBookIds.join(','),
        })
        .then(function () {
          search(state.lastSearchText);
        })
    }

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
      allChange,
    }
  }
})
</script>
