import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import axios from 'axios'
import swal from 'sweetalert2'
import moment from 'moment'
import VueDraggableResizable from 'vue-draggable-resizable'

// class
import Clock from './class/clock.js'

// Native JS prototypes
Array.prototype.totalFlat = (arr1) => {
   return arr1.reduce((acc, val) => Array.isArray(val) ? acc.concat(flattenDeep(val)) : acc.concat(val), [])
}

Vue.prototype.$axios    = axios
const token = document.head.querySelector('meta[name="csrf-token"]')
Vue.prototype.$axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content

Vue.prototype.$swal     = swal
Vue.prototype.$moment   = moment
Vue.prototype.$base_url = window.location.origin
Vue.prototype.$redirect = path => window.location = path

Vue.prototype.$time = function (time) {
  return moment(time).utcOffset(-6).format('h:mm:ss A')
}
Vue.prototype.$date = function (date) {
  return moment(date).utcOffset(-6).format('DD/MM/YYYY')
}
Vue.prototype.$dateText = function (dateUnformat) {
  const date = moment(dateUnformat).utcOffset(-6)
  const day = date.date()
  const month = date.month()
  const year = date.year()
  let monthText = ''
  switch (month + 1) {
    case 1:
      monthText = 'Enero'
      break
    case 2:
      monthText = 'Febrero'
      break
    case 3:
      monthText = 'Marzo'
      break
    case 4:
      monthText = 'Abril'
      break
    case 5:
      monthText = 'Mayo'
      break
    case 6:
      monthText = 'Junio'
      break
    case 7:
      monthText = 'Julio'
      break
    case 8:
      monthText = 'Agosto'
      break
    case 9:
      monthText = 'Septiembre'
      break
    case 10:
      monthText = 'Octubre'
      break
    case 11:
      monthText = 'Noviembre'
      break
    case 12:
      monthText = 'Diciembre'
      break

    default:
      monthText = '?'
      break
  }
  return `${day} de ${monthText} de ${year}`
}
Vue.prototype.$datetime = function (datetime) {
  return moment(datetime).utcOffset(0).format('DD/MM/YYYY h:mm:ss A')
}


Vue.prototype.$setSettings = (name, data) => {
  Vue.prototype.$axios.post('/settings', { name, data })
  .then(({data}) => {})
  .catch(err => { console.log('Error', err) })
}

Vue.prototype.$getSettings = (name, callback) => {
  Vue.prototype.$axios.get(`/settings/${name}.json`, { name })
  .then(({data}) => callback(data.setting.data))
  .catch(err => { callback(err) })
}

Vue.prototype.$getSettings('time', (data) => {
  const serverTime = new Date(data)
  Vue.prototype.$clock = new Clock(
    serverTime,
    0, // format
    1 // speed
  )
})

Vue.component('vue-draggable', VueDraggableResizable)

import '../css/tailwind.css'

import Layout       from '../components/Layout/'

import Pages        from '../views/pages/'
import Simulation   from '../views/pages/Simulation'

import Floors       from '../views/floors/'
import Networks     from '../views/networks/'
import UnitTypes    from '../views/unit_types/'
import Environments from '../views/environments/'
import Interfaces   from '../views/interfaces/'
import Sensors      from '../views/sensors/'
import Actuators    from '../views/actuators/'
import Devices      from '../views/devices/'
import DeviceTypes  from '../views/devices/types/'

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
      Environments,
      Sensors,
      Actuators,
      Devices,
      DeviceTypes
    }
  })
})
