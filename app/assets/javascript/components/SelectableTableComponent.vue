<template>
  <!-- a-table に自動で付与されるページネーション機能だと、全件を取得した前提でのページネーションとなる -->
  <!-- ページネーション毎にAPIにアクセスする仕様に向いていないため、:pagination="false" とし、別に a-pagination を定義する -->
  <a-table
    :dataSource="$props.data"
    :columns="$props.columns"
    :rowKey="$props.rowKey"
    :row-selection="{selectedRowKeys: $props.selectedRowKeys, onChange: onChangeSelection }"
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
import { defineComponent } from 'vue'

export default defineComponent({
  //親コンポーネントからのデータ受け取り
  props: {
    columns:         { type: Array,  required: true },
    data:            { type: Array,  required: true },
    currentPage:     { type: Number, required: true },
    total:           { type: Number, required: true },
    rowKey:          { type: String, required: false, default: "id" },
    selectedRowKeys: { type: Array,  required: true },
  },
  emits: ['onChangePage', 'onChangeSelect'],
  setup(_props, context) {
    const onChangeSelection = (selectedRowKeys) => {
      context.emit('onChangeSelection', selectedRowKeys)//カスタムイベントを発生
      //親コンポーネントに選択された行のキーを送信
    };
    //貸し出し中の本を選択できなくする記述（実装方法検討中）
    //BookListPage側の都合で以下をコメントアウトすると正しく描画されない
    const rentableState = ()=>{
      context.emit('rentableState')
    };
    
    return {
      onChangeSelection,
      rentableState,
    }
  }
})
</script>
