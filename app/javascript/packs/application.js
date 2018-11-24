import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import axios from 'axios'
import swal from 'sweetalert2'
import moment from 'moment'
import VueDraggableResizable from 'vue-draggable-resizable'

Vue.component('vue-draggable', VueDraggableResizable)

import '../css/tailwind.css'

import Layout       from '../components/Layout/'

import Pages        from '../views/pages/'
import Simulation   from '../views/pages/Simulation'

import Floors       from '../views/floors/'
import Networks     from '../views/networks/'
import UnitTypes    from '../views/unit_types/'
import Interfaces   from '../views/interfaces/'
import Sensors      from '../views/sensors/'
import Actuators    from '../views/actuators/'
import Devices      from '../views/devices/'
import DeviceTypes  from '../views/devices/types/'

Vue.prototype.$axios    = axios
Vue.prototype.$swal     = swal
Vue.prototype.$moment   = moment
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
      Simulation,
      Layout,
      Floors,
      Networks,
      Interfaces,
      UnitTypes,
      Sensors,
      Actuators,
      Devices,
      DeviceTypes
    }
  })
})
