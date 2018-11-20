import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import axios from 'axios'
import swal from 'sweetalert2'
import moment from 'moment'

import '../css/tailwind.css'

import Layout from '../components/Layout/'
import Pages from '../views/pages/'

import Floors from '../views/floors/'
import Networks from '../views/networks/'
import Interfaces from '../views/interfaces/'
import UnitTypes from '../views/unit_types/'

Vue.prototype.$axios = axios
Vue.prototype.$swal = swal
Vue.prototype.$moment = moment
Vue.prototype.$base_url = window.location.origin
Vue.prototype.$redirect = path => window.location = path

let token = document.head.querySelector('meta[name="csrf-token"]')
Vue.prototype.$axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({ // eslint-disable-line
    el: '#app',
    components: {
      Pages,
      Layout,
      Floors,
      Networks,
      Interfaces,
      UnitTypes
    }
  })
})
