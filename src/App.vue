<template>
  <div id="app">
    <ApologyComponent />
  </div>
</template>

<script>
import ApologyComponent from './other_components/ApologyComponent.vue';

export default {
  name: 'App',
  components: {
    ApologyComponent
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
