<template>
  <div class="tab-contents">
    <iframe :src="framePath" width="100%" height="100%"></iframe>
  </div>
</template>

<script>
  import {API_BASE} from "../utils";

  export default {
    name: "ContainerTab",
    props: ['params'],
    data() {
      return {
      }
    },
    computed: {
      framePath() {
        return `${API_BASE}/open-container?host=${this.params.host}&port=${this.params.port}`;
      }
    },
  }
</script>

<style scoped>

  .tab-contents {
    width: 100%;
    height: 100%;
  }

  iframe {
    display: block;
    border: none;
    margin: 0;
    padding: 0;
  }

</style>
