<template>

  <a-row type="flex" justify="space-between">
    <a-col>
      <a-typography-title :level="2">図書一覧</a-typography-title>
    </a-col>
    <a-col>
      <a-checkbox 
      v-model:checked = "firstRentableFlg"
      @change="onChange">
        <a-typography-title :level="5">貸し出し中の書籍を表示しない</a-typography-title>
      </a-checkbox>
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
    :currentPage="state.currentPage"
    :isBookList = true
    @onChangePage="changePage($event)"
    @onChangeSelection="updateSelections($event)"><!--子コンポーネントのイベント受け取り(?)-->    
    <template v-slot:actionArea>
      <a-button type="primary" @click="rentBooks()" :disabled="state.selectedBookIds.length === 0">
        借りる
      </a-button>
    </template>
  </selectable-table>
</template>

<script>
/*
メモ dataのテーブルは以下のようになっている前提で開発
id | title | author_name | user_name | is_rentable | category_id|
------------------------------------------------------------------
*/
import { defineComponent, reactive, ref } from 'vue'
import axios from 'axios';
import { message } from 'ant-design-vue';
import selectableTable from "./SelectableTableComponent";
let rentableOnlyFlg = true
let tmpPage = 1
let tmpSearchText = ''
export default defineComponent({//JSとVue.jsの境界
  components: {
    selectableTable
  },
  setup(_props) {
    const ROWS_PER_PAGE = 10; // 1ページあたりの表示行数

    const COLUMNS = [
      {title: 'タイトル',dataIndex: 'title',ellipsis: true,},
      {title: 'カテゴリ',dataIndex: 'category_id',width: '200px',ellipsis: true,},
      {title: '著者',dataIndex: 'author_name',width: '200px',ellipsis: true,},
      {title: '貸し出し状況',dataIndex: 'is_rentable',width: '200px',ellipsis: true,},
      {title: '借主名',dataIndex: 'user_name',width: '200px',ellipsis: true,},
    ];

    const state = reactive({//変数初期値
      books: [],
      totalBooks: 0,
      searchText: '',
      selectedBookIds: [],
      currentPage: 1,
    });
    let lastSearchText = ''; // ページング時はテキストボックスの内容に依らず検索させるため、別に保持させる

    const search = (searchText, page = 1) => {
      let offset = (page - 1) * ROWS_PER_PAGE
      axios
        .get('/api/v1/books/',{
          params: {
            search_text: searchText,
            rentable: rentableOnlyFlg,
            limit: ROWS_PER_PAGE,
            offset: offset,//ページの最初に来るデータの設定
          },
        })
        .then(function (response) {
          state.books = response.data.data;
          state.totalBooks = response.data.count;
          state.currentPage = page;
          tmpPage = page;
          tmpSearchText = searchText;
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
        });
    }

    const changePage = (page) => {
      search(lastSearchText, page);
    };

    const updateSelections = (selectedRowKeys) => {
      state.selectedBookIds = selectedRowKeys;//チェックされた行のBookId一覧を取得
    };
    const onChange = (e) =>{//チェックボックスがチェックされた
      if(e.target.checked){//貸し出し中を表示しないとき
        //console.log('checked, rentableOnlyFlg:%s', rentableOnlyFlg);//デバック用ログ
        rentableOnlyFlg = true;
        search(tmpSearchText,tmpPage);
      }
      else{//貸し出し中を表示するとき
        //console.log('unchecked');//デバック用ログ
        rentableOnlyFlg = false;
        search(tmpSearchText,tmpPage);
      }
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
      onChange,
      firstRentableFlg: ref(rentableOnlyFlg),
    }
  },
  
  
})
</script>
