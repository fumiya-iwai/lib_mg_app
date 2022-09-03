<template>
  <!-- a-table に自動で付与されるページネーション機能だと、全件を取得した前提でのページネーションとなる -->
  <!-- ページネーション毎にAPIにアクセスする仕様に向いていないため、:pagination="false" とし、別に a-pagination を定義する -->

  <!--:row-selection="rowSelectionにすればチェックボックスの状態の変更可能"-->
  <!--ただしページを跨いだ際のチェックを外す処理なド一部が無効化-->
  <a-table
    :dataSource="$props.data"
    :columns="$props.columns"
    :rowKey="$props.rowKey"
    :row-selection="{ getCheckboxProps:getCheckboxProps, selectedRowKeys: $props.selectedRowKeys, onChange: onChangeSelection }"
    :pagination="false"
    :scroll="{ x: 800 }"
    :custom-row="customRow"/>

  <a-row type="flex" justify="space-between" style="margin-top: 20px;">
    <a-col>
      <a-pagination
        :current="$props.currentPage"
        :total="$props.total"
        :hideOnSinglePage="true"
        @change="$emit('onChangePage', $event)"/>
    </a-col>
    <a-col>
      <slot name="actionArea"></slot>
    </a-col>
  </a-row>
</template>

<script>
//tmemplate部分のrow-selectionでチェックボックス追加
import { defineComponent, computed } from 'vue'

export default defineComponent({
  //親コンポーネントからのデータ受け取り
  props: {
    columns:         { type: Array,  required: true },
    data:            { type: Array,  required: true },
    currentPage:     { type: Number, required: true },
    total:           { type: Number, required: true },
    rowKey:          { type: String, required: false, default: "id" },
    selectedRowKeys: { type: Array,  required: true },
    isBookList:      { type: Boolean, required: true},//図書一覧からのアクセスかどうか
  },
  emits: ['onChangePage', 'onChangeSelect'],
  setup(props, context) {
    console.log("data:");
    console.log(props.title);
    const onChangeSelection = (selectedRowKeys) => {
      context.emit('onChangeSelection', selectedRowKeys)//カスタムイベントを発生
      //親コンポーネントに選択された行のキーを送信
    };
    const getCheckboxProps = (record) => ({
        //チェックボックスのステータス変更
        //BookListPageからのアクセスかつdisableCheckBoxが真ならチェックボックス無効化
        disabled: props.isBookList && disableCheckBox(record),
      });
    //レコードのチェックボックス有効無効の条件を定義
    const disableCheckBox = (record) =>{
      return true;//trueを返すと図書一覧では無効化される
    };
    const customRow = (record) => {
      //貸出一覧返却期限が過ぎている本があれば
      //レコードの背景を赤くする処理の実装部分
      if(!props.isBookList && record.title === 'test_data1'){
        return {style: {
          'background-color': '#e04848'
        }};
      }
      
    };
    return {
      onChangeSelection,
      getCheckboxProps,
      customRow,
    }
  }
})
</script>
