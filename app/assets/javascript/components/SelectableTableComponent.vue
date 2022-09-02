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
    :scroll="{ x: 800 }"/>

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
    const onChangeSelection = (selectedRowKeys) => {
      context.emit('onChangeSelection', selectedRowKeys)//カスタムイベントを発生
      //親コンポーネントに選択された行のキーを送信
    };
    const getCheckboxProps = (record) => ({
        //チェックボックスのステータス変更
        disabled: props.isBookList,
      });
    return {
      onChangeSelection,
      getCheckboxProps,
    }
  }
})
</script>
