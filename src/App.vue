<template>
  <div id="app">

    <!-- Route dynamique : le contenu dépend de la route active -->
    <router-view />

  </div>
</template>

<script>

  export default {
    name: "App",
    components: {

    },
    data() {
      return {
        scrolledPastHeader: false, // Contrôle si l'utilisateur a défilé
      };
    },
    methods: {
      handleScroll() {
        const header = this.$refs.header?.$el;
        const headerHeight = header ? header.offsetHeight : 100; // Mesure la hauteur réelle
        this.scrolledPastHeader = window.scrollY > headerHeight;
      },
    },
    mounted() {
      window.addEventListener("scroll", this.handleScroll); // Attache l'événement scroll
    },
    beforeUnmount() {
      window.removeEventListener("scroll", this.handleScroll); // Nettoie l'événement
    },
  };
</script>

<style>
/* Global styles */
body {
  margin: 0;
  background-color: white;
  color: white;
}
*{
  font-family: 'Banks Miles Single Line';
}
</style>
