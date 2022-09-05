<template>

  <a-row type="flex" justify="space-between">
    <a-col>
      <a-typography-title :level="2">図書一覧</a-typography-title>
    </a-col>
    <a-col>
      <a-checkbox 
      v-model:checked = "firstRentableFlg"
      @change="onChange">
        <a-typography-title :level="5">貸出可能のみ表示する</a-typography-title>
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
    :isRentable ="state.isRentable"
    :rentBooks = "state.rentBooks"
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
id | title | author_name | rental_user_name | is_rentable | category_id|
------------------------------------------------------------------
*/
import { defineComponent, reactive, ref } from 'vue'
import axios from 'axios';
import { message } from 'ant-design-vue';
import selectableTable from "./SelectableTableComponent";
let rentableOnlyFlg = false
let tmpPage = 1
let tmpSearchText = ''
export default defineComponent({//JSとVue.jsの境界
  components: {
    selectableTable
  },
  setup(_props,context) {
    const ROWS_PER_PAGE = 10; // 1ページあたりの表示行数

    const COLUMNS = [
      {title: 'タイトル',dataIndex: 'title',ellipsis: true,},
      {title: 'カテゴリ',dataIndex: 'category_id',width: '200px',ellipsis: true,},
      {title: '著者',dataIndex: 'author_name',width: '200px',ellipsis: true,},
      {title: '貸し出し状況',dataIndex: 'rental_state',width: '200px',ellipsis: true,},
      {title: '借主名',dataIndex: 'rental_user_name',width: '200px',ellipsis: true,},
    ];

    const state = reactive({//変数初期値
      books: [],
      totalBooks: 0,
      searchText: '',
      selectedBookIds: [],
      currentPage: 1,
      //rentBooks: [],
      //hoge: [],
      //isRentable: [],
    });
    let lastSearchText = ''; // ページング時はテキストボックスの内容に依らず検索させるため、別に保持させる

    const search = (searchText, page = 1) => {
      let offset = (page - 1) * ROWS_PER_PAGE
      axios
        .get('/api/v1/books/',{
          params: {//APIに渡す値の設定
            search_text: searchText,
            rentable: rentableOnlyFlg,
            limit: ROWS_PER_PAGE,
            offset: offset,//ページの最初に来るデータの設定
          },
        })
        .then(function (response) {
          console.log("hogee");
          console.log(response);
          //state.rentBooks = response.data.data_rented;
          state.books = response.data.data;
          state.rentBooks = response.data.data_rented;
          state.totalBooks = response.data.count;
          state.currentPage = page;
          //state.hoge = state.books.concat(state.rentBooks)
          //state.isRentable = state.hoge.is_rentable;
          //console.log(state.hoge[0].is_rentable);
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
          context.emit('updatepoint');
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
        search(tmpSearchText,1);
      }
      else{//貸し出し中を表示するとき
        //console.log('unchecked');//デバック用ログ
        rentableOnlyFlg = false;
        search(tmpSearchText,1);
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
