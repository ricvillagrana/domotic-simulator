import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import "../css/tailwind.css"
import axios from 'axios'
import swal from 'sweetalert2'
import moment from 'moment'

import Layout from '../components/Layout/'
import Pages from '../views/pages/'

Vue.prototype.$axios = axios;
Vue.prototype.$swal = swal;
Vue.prototype.$moment = moment;
Vue.prototype.$base_url = window.location.origin
Vue.prototype.$redirect = path => window.location = path 

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    components: {
      Pages, Layout
    }
  })
})
