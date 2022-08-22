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

  <selectable-table
    :columns="COLUMNS"
    :data="state.books"
    :total="state.totalBooks"
    :selectedRowKeys="state.selectedBookIds"
    @onChangePage="changePage($event)"
    @onChangeSelection="updateSelections($event)">
    <template v-slot:actionArea>
      <a-button type="primary" @click="rentBooks()" :disabled="state.selectedBookIds.length === 0">
        借りる
      </a-button>
    </template>
  </selectable-table>
</template>

<script>
import { defineComponent, reactive } from 'vue'
import axios from 'axios';
import { message } from 'ant-design-vue';
import selectableTable from "./SelectableTableComponent";

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
    ];

    const state = reactive({
      books: [],
      totalBooks: 0,
      searchText: '',
      selectedBookIds: [] ,
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

    const updateSelections = (selectedRowKeys) => {
      state.selectedBookIds = selectedRowKeys;
    };

    // 初期リスト作成
    search('', 1);

    return {
      COLUMNS,
      state,
      search,
      rentBooks,
      changePage,
      updateSelections,
    }
  }
})
</script>
