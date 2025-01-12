<template>
  <div id="app">
    <ScavengerHunt />
  </div>
</template>

<script>
import ScavengerHunt from './components/ScavengerHunt.vue';

export default {
  name: 'App',
  components: {
    ScavengerHunt
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
