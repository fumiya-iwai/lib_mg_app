import { createRouter, createWebHashHistory } from 'vue-router'
import HomePage from '../components/HomePage.vue'
import UserListPage from '../components/UserListPage.vue'
import UserRegisterPage from '../components/UserRegisterPage.vue'

const routes = [
  { path: '',                component: HomePage },
  { path: '/users',          component: UserListPage },
  { path: '/users/register', component: UserRegisterPage }
];

const router = createRouter({
  history: createWebHashHistory('/main'),
  routes
})

export default router
