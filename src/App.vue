<template>
  <div id="app">
    <div class="tabs-panel">
      <div class="tab" :class="{active: idx === currentTabIndex}" v-for="(tab, idx) in tabList" @click="currentTabIndex = idx">
        {{ tab.name }}
        <div class="close-button" @click.stop="closeTab(idx)"><img src="./assets/close.png"/></div>
      </div>
    </div>

    <div class="content-wrapper">
      <div class="content" v-for="(tab, idx) in tabList" v-show="idx === currentTabIndex">
        <component :is="tab.comp" :params="tab.params" @create-tab="createTab"></component>
      </div>
    </div>
  </div>
</template>

<script>

  import ListTab from "./components/ListTab";
  import ContainerTab from "./components/ContainerTab";

  const DEFAULT_TAB = {
    name: 'Список контейнеров',
    comp: ListTab,
    params: {}
  };

  export default {
    name: 'App',
    components: {
    },
    data() {
      return {
        tabList: [],
        currentTabIndex: 0,
      }
    },
    created() {
      this.tabList.push(DEFAULT_TAB);
    },
    methods: {
      createTab(tabName, params) {
        if(this.tabList.find((tab) => tab.name === tabName)) return;
        this.tabList.push({
          name: tabName,
          comp: ContainerTab,
          params: params
        });
        this.currentTabIndex = this.tabList.length - 1;
      },
      closeTab(tabIdx) {
        this.tabList.splice(tabIdx, 1);
        this.currentTabIndex = 0;
      }
    },
  }

</script>

<style>
  body {
    margin: 0;
    padding: 0;
    font-family: Avenir, Helvetica, Arial, sans-serif;
  }
</style>

<style scoped lang="scss">

  #app {
    display: flex;
    flex-flow: column nowrap;
    width: 100vw;
    height: 100vh;
  }

  .tabs-panel {
    border-bottom: 1px solid black;
    display: flex;
    flex-flow: row wrap;

    .tab {
      position: relative;
      min-width: 80px;
      padding: 10px 35px 10px 15px;
      cursor: default;
      border-right: 1px dotted black;
      user-select: none;

      &:not(.active) {
        cursor: pointer;

        &:hover {
          background-color: #e2e2e2;
        }
      }

      &.active {
        background-color: #bfd3ff;
      }

      .close-button {
        position: absolute;
        right: 4px;
        top: 10px;
        cursor: pointer;

        img {
          width: 18px;
        }

        &:not(:hover) img {
          filter: invert(1);
        }
      }

      &:nth-child(1) {
        padding-right: 15px;
        .close-button {
          display: none;
        }
      }
    }
  }

  .content-wrapper {
    flex: 1;
    position: relative;
  }

  .content {
    position: absolute;
    top: 0; bottom: 0; left: 0; right: 0;
    overflow: hidden;
  }

</style>
