import { Module, VuexModule, Mutation, Action, getModule } from 'vuex-module-decorators'
import store from '@/store';
import config from '../../config';

export interface Inventory {
  id: string;
  createdTime: string;
  fields: {
    Posted: string;
    "Product Code": string;
  };
}

@Module({
  dynamic: true,
  namespaced: true,
  name: 'inventory',
  store,
})
class InventoryModule extends VuexModule {
  fetching: boolean = false;
  sending: boolean = false;
  inventory: Inventory[] = [];

  @Mutation
  setFetching(fetching: boolean) {
    this.fetching = fetching;
  }

  @Mutation
  setInventory(inventory: Inventory[]) {
    this.inventory = inventory;
  }

  @Action
  async fetchInventory() {
    this.context.commit('setFetching',true)
    const response = await fetch(
      "https://api.airtable.com/v0/appJkRh9E7qNlXOav/Home?offset=0&maxRecords=100&view=Grid%20view",
      {
        headers: {
          Authorization: config.Authorization
        }
      }
    )
    const body = await response.json();
    this.context.commit('setInventory',body.records);
    this.context.commit('setFetching', false);
  }
}

export default getModule(InventoryModule);