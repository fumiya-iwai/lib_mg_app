import { createRouter, createWebHashHistory } from 'vue-router'
import HomePage from '../components/HomePage.vue'
import AuthorRegistrationPage from '../components/AuthorRegistrationPage.vue'
import BookRegistrationPage from '../components/BookRegistrationPage.vue'
import BookListPage from '../components/BookListPage.vue'
import RentalListPage from '../components/RentalListPage.vue'

const routes = [
  { path: '', redirect: '/books' },
  { path: '/books', component: BookListPage, name: 'books' },
  { path: '/rentals', component: RentalListPage, name: 'rentals' },
  { path: '/books/new', component: BookRegistrationPage, name: 'book' },
  { path: '/authors/new', component: AuthorRegistrationPage, name: 'author' },
];

const router = createRouter({
  history: createWebHashHistory('/main'),
  routes
})

export default router
