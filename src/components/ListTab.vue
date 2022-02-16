<template>
  <div class="tab-contents">
    <div class="action" @click="loadDocker"><img src="../assets/reload.png"/></div>
    <div class="container-list">
      <div class="container" v-for="container in containerList">
        <div class="status" v-if="container.isup"><img src="../assets/play.png"/></div>
        <div class="status" v-else><img src="../assets/stop.png"/></div>
        <div class="name" :class="{browseable: container.browseable}" @click="openContainer(container)">{{ container.name }}</div>
        <div class="uptime">{{ container.uptime }}</div>
        <div class="action" v-if="container.isup" @click="sendCommand(container.name, 'stop')"><img src="../assets/stop.png"/></div>
        <div class="action" v-else @click="sendCommand(container.name, 'start')"><img src="../assets/play.png"/></div>
        <div class="action" @click="sendCommand(container.name, 'restart')"><img src="../assets/reset.png"/></div>
      </div>
    </div>
  </div>
</template>

<script>
  import {getApi} from "../utils";

  const DEFAULT_PORT = 80;
  const REFRESH_INTERVAL = 120 * 1000;

  export default {
    name: "ListTab",
    data() {
      return {
        containerList: []
      }
    },
    created() {
      this.loadDocker();
      setInterval(() => {
        this.loadDocker();
      }, REFRESH_INTERVAL);
    },
    methods: {
      async loadDocker() {
        let containerList = await getApi('containers');
        this.containerList = [];
        for(let cont of containerList) {
          let port = Object.keys(cont.ports).map(port => (port.match(/^(\d+)\/tcp$/) || [null, null])[1]).sort((a, b) => a - b)[0];
          this.containerList.push({
            name: cont.name,
            params: {
              host: cont.name,
              port: port
            },
            browseable: !!port,
            isup: cont.status === 'running',
            uptime: '', // cont.status.startsWith('Up') ? cont.status.replace('Up ', '') : ''
          })
        }
        this.containerList.sort((a, b) => (a.name > b.name ? 1 : -1));
        // this.containerList.sort((a, b) => (parseInt(a.name.replace(/\D/g, '0')) - parseInt(b.name.replace(/\D/g, '0'))));
      },
      openContainer(container) {
        if(!container.browseable) return;
        this.$emit('create-tab', container.name, container.params);
      },
      async sendCommand(container, command) {
        if(confirm(`${command} ${container} ?`)) {
          await getApi(`container/${container}/power/${command}`);
        }
      }
    },
  }
</script>

<style lang="scss" scoped>

  .tab-contents {
    display: flex;
    flex-flow: row nowrap;
    height: 100%;
    overflow: auto;
  }

  .action {
    padding: 6px;

    cursor: pointer;
    img {
      display: block;
      height: 30px;
    }

    &:not(:hover) {
      img {
        filter: grayscale(0.9);
      }
    }
  }
  .container-list {
    width: 500px;
    user-select: none;
  }

  .container {
    display: flex;
    flex-flow: row nowrap;
    justify-content: space-between;
    align-items: center;

    &:nth-child(odd) {
      background-color: #f3f3f3;
    }

    .status {
      padding: 6px;

      img {
        display: block;
        height: 20px;
      }
    }

    .action {
      padding: 10px;
      img {
        height: 20px;
      }
    }

    .name {
      flex: 1;
      padding: 8px;

      &.browseable {
        cursor: pointer;
        &:hover {
          text-decoration: underline;
          font-weight: bold;
        }
      }
    }

    .uptime {
      font-size: 0.8em;
    }

    &:not(:hover) {
      .status {
        img {
          filter: grayscale(0.5);
        }
      }
    }
  }

</style>
