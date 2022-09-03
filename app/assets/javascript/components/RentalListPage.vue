<template>
  <a-row type="flex" justify="space-between">
    <a-col>
      <a-typography-title :level="2">貸出一覧</a-typography-title>
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

  <selectable-table
    :columns="COLUMNS"
    :data="state.rentals"
    :total="state.totalRentals"
    :selectedRowKeys="state.selectedRentalIds"
    :currentPage="state.currentPage"
    :isBookList = false
    @onChangePage="changePage($event)"
    @onChangeSelection="updateSelections($event)">
    <template v-slot:actionArea>
      <a-button type="primary" @click="returnBooks()" :disabled="state.selectedRentalIds.length === 0">
        返却する
      </a-button>
    </template>
  </selectable-table>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';
import { message } from "ant-design-vue";
import selectableTable from './SelectableTableComponent.vue'

export default defineComponent({
  components: {
    selectableTable
  },
  setup(_props) {
    const ROWS_PER_PAGE = 10; // 1ページあたりの表示行数
    const COLUMNS = [
      {
        title: 'タイトル',
        dataIndex: 'title',
        ellipsis: true,
      },
      {
        title: '著者',
        dataIndex: 'author_name',
        width: '200px',
        ellipsis: true,
      },
      {
        title: '貸出日',
        dataIndex: 'rented_date',
        width: '120px',
      },
      {
        title: '返却予定日',
        dataIndex: 'scheduled_return_date',
        width: '120px',
      },
    ];

    const state = reactive({
      rentals: [],
      totalRentals: 0,
      searchText: '',
      selectedRentalIds: [],
      currentPage: 1,
    });
    let lastSearchText = ''; // ページング時はテキストボックスの内容に依らず検索させるため、別に保持させる

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
          state.rentals = response.data.data;
          state.totalRentals = response.data.count;
          state.currentPage = page;
          // テキストボックスが変更された状態でページネーションされた場合を考慮し、
          // 検索処理で使用された条件に上書きしておく
          state.SearchText = searchText;
          lastSearchText = searchText;
          // 検索後はチェックボックスの選択状態を初期化する（ページを跨いで選択させない）
          state.selectedRentalIds = [];
        })
        console.log("title");
        console.log(state.rentals);
    }

    const returnBooks = () => {
      axios
        .put('/api/v1/rentals/return',{
          rental_ids: state.selectedRentalIds.join(','),
        })
        .then(function () {
          message.success(`${state.selectedRentalIds.length}冊の本を返却しました。`, 3);
          search(lastSearchText, 1);
        });
    }

    const changePage = (page) => {
      search(lastSearchText, page);
    };

    const updateSelections = (selectedRowKeys) => {
      state.selectedRentalIds = selectedRowKeys;
    };

    // 初期リスト作成
    search('', 1);

    return {
      COLUMNS,
      state,
      search,
      returnBooks,
      changePage,
      updateSelections,
    }
  }
})
</script>
