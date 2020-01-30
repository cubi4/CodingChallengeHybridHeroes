<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button></ion-back-button>
        </ion-buttons>
        <ion-title>Inventory</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-list>
        <ion-item v-for="product in inventory" v-bind:key="product.id">
          <ion-label>{{ product.fields['Product Code'] }}</ion-label>
          <ion-note slot="end">{{ getDate(product) }}</ion-note>
        </ion-item>
      </ion-list>
      <ion-fab vertical="bottom" horizontal="end" slot="fixed">
        <ion-fab-button @click="presentCamera()">
          <ion-icon name="add"></ion-icon>
        </ion-fab-button>
      </ion-fab>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import InventoryModule, { Inventory } from '@/store/modules/inventory';
import { Component, Vue } from 'vue-property-decorator';

@Component({
  name: 'Home'
})
export default class HomeComponent extends Vue {

get inventory() {
    return InventoryModule.inventory;
  }

  created() {
    InventoryModule.fetchInventory();
  }

  getDate(record: Inventory) {
    const date = new Date(record.fields.Posted)
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
  }

  presentCamera() {
    alert('camera');
  }
};
</script>
