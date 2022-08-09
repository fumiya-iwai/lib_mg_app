import { createRouter, createWebHashHistory } from 'vue-router'
import HomePage from '../components/HomePage.vue'
import AuthorRegistrationPage from '../components/AuthorRegistrationPage.vue'
import BookRegistrationPage from '../components/BookRegistrationPage.vue'
import BookListPage from '../components/BookListPage.vue'
import RentalListPage from '../components/RentalListPage.vue'

const routes = [
  { path: '',           component: HomePage },
  { path: '/authors/new',   component: AuthorRegistrationPage },
  { path: '/books/new',     component: BookRegistrationPage },
  { path: '/books',    component: BookListPage },
  { path: '/rentals',    component: RentalListPage },
];

const router = createRouter({
  history: createWebHashHistory('/main'),
  routes
})

export default router
