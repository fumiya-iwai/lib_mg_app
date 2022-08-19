<template>
  <h1>貸出一覧</h1>
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
          <th>貸出期間</th>
        </tr>
        <tr v-for="rental in state.rentals" >
          <td><input type="checkbox" :value="rental.id" v-model="state.selectedRentalIds" ></td>
          <td>{{ rental.title }}</td>
          <td>{{ rental.author_name }}</td>
          <td>{{ rental.rented_date }} 〜 {{ rental.scheduled_return_date }}</td>
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
      <button @click="returnBooks()">返却する</button>
    </div>
  </div>
</template>

<style>
/*table {*/
/*  border-collapse: collapse;*/
/*}*/
/*th, td {*/
/*  border: 1px solid #333;*/
/*}*/
</style>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';

export default defineComponent({
  name: "rental list",
  setup(_props) {
    const state = reactive({ rentals: [], currentPage: 1, maxPage: 1, searchText: '', lastSearchText: '', selectedRentalIds: [] ,allChecked: false}); // TODO: 型定義とかしておくべき？
    const ROWS_PER_PAGE = 8;

    const search = (searchText, page = 1) => {
      let offset = (page - 1) * ROWS_PER_PAGE
      axios
        .get('/api/v1/rentals/',{
          params: {
            search_text: searchText,
            rentable: true,
            limit: ROWS_PER_PAGE,
            offset: offset,
          },
        })
        .then(function (response) {
          state.allChecked = false;
          state.selectedRentalIds = [];
          state.lastSearchText = searchText;
          state.currentPage = page;
          state.rentals = response.data.data;
          state.maxPage = Math.floor(response.data.count / ROWS_PER_PAGE) + 1;
        })
    }

    const returnBooks = () => {
      axios
        .put('/api/v1/rentals/return',{
          rental_ids: state.selectedRentalIds.join(','),
        })
        .then(function () {
          search(state.lastSearchText);
        })
    }

    const allChange = () => {
      if (state.allChecked) {
        state.selectedRentalIds = state.rentals.map(rental => rental.id);
      } else {
        state.selectedRentalIds = [];
      }
    }

    // 初期リスト作成
    search();

    return {
      state,
      returnBooks,
      search,
      allChange,
    }
  }
})
</script>
