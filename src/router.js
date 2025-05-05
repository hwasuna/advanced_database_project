import { createRouter, createWebHistory } from "vue-router";

import RegisterView from "@/views/RegisterView.vue";

const routes = [
    {
        path: '/register',
        name: 'Register',
        component: RegisterView,
    },
];

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes,
    scrollBehavior(to, from, savedPosition) {
        // Si une position sauvegardée existe (par exemple, après avoir utilisé "back"), utilise-la
        if (savedPosition) {
          return savedPosition;
        }
        // Sinon, fais défiler en haut de la page
        return { top: 0 };
      },
  });

export default router;