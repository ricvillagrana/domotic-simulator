<template>
  <app-modal class="max-h-screen" :open="open" @close="$emit('close')" :size="'3/4'">
    <div slot="header">
      Configurando {{ currentDevice.name }}
    </div>
    <div slot="content" v-if="server.sensors && server.actuators && server.interfaces">
      <div class="flex flex-row flex-wrap">
        <div class="flex flex-col w-1/2">
          <p class="title text-xl">En dispositivo</p>
          <div class="flex flex-col w-full h-96 overflow-scroll">
            <p class="flex title text-blue my-2">Sensores</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onRemove(sensor, 'sensor')" class="flex justify-center items-center text-center px-2 py-1" v-for="(sensor, index) in currentDevice.sensors" :key="`sensor-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-blue-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ sensor.name }}</p>
                  <img class="w-6" v-if="sensor.symbol_off" :src="sensor.symbol_off.url" :alt="sensor.symbol_off.name">
                </div>
              </div>
              <span v-if="!currentDevice.sensors || currentDevice.sensors.length === 0" class="text-grey-darkest font-bold">No hay Sensores</span>
            </div>

            <p class="flex title text-green my-2">Actuadores</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onRemove(actuator, 'actuator')" class="flex justify-center items-center text-center px-2 py-1" v-for="(actuator, index) in currentDevice.actuators" :key="`actuator-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-green-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ actuator.name }}</p>
                  <img class="w-6" v-if="actuator.symbol_off" :src="actuator.symbol_off.url" :alt="actuator.symbol_off.name">
                </div>
              </div>
              <span v-if="!currentDevice.actuators || currentDevice.actuators.length === 0" class="text-grey-darkest font-bold">No hay Actuadores</span>
            </div>

            <p class="flex title text-purple my-2">Interfaces de red</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onRemove(inter, 'interface')" class="flex justify-center items-center text-center px-2 py-1" v-for="(inter, index) in currentDevice.interfaces" :key="`interface-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-purple-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ inter.name }}</p>
                  <img class="w-6" v-if="inter.symbol_off" :src="inter.symbol_off.url" :alt="inter.symbol_off.name">
                </div>
              </div>
              <span v-if="!currentDevice.interfaces || currentDevice.interfaces.length === 0" class="text-grey-darkest font-bold">No hay Interfaces de Red</span>
            </div>
          </div>
        </div>
        <div class="flex flex-col w-1/2">
          <p class="title text-xl">Disponibles</p>
          <div class="flex flex-col w-full h-96 overflow-scroll">
            <p class="flex title text-blue my-2">Sensores</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onAppend(sensor, 'sensor')" class="flex justify-center items-center text-center px-2 py-1" v-for="(sensor, index) in server.sensors" :key="`sensor-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-blue-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ sensor.name }}</p>
                  <img class="w-6" v-if="sensor.symbol_off" :src="sensor.symbol_off.url" :alt="sensor.symbol_off.name">
                </div>
              </div>
              <span v-if="server.sensors.length === 0" class="text-grey-darkest font-bold">No hay Sensores</span>
            </div>

            <p class="flex title text-green my-2">Actuadores</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onAppend(actuator, 'actuator')" class="flex justify-center items-center text-center px-2 py-1" v-for="(actuator, index) in server.actuators" :key="`actuator-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-green-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ actuator.name }}</p>
                  <img class="w-6" v-if="actuator.symbol_off" :src="actuator.symbol_off.url" :alt="actuator.symbol_off.name">
                </div>
              </div>
              <span v-if="server.actuators.length === 0" class="text-grey-darkest font-bold">No hay Actuadores</span>
            </div>

            <p class="flex title text-purple my-2">Interfaces de red</p>
            <div class="flex flex-row flex-wrap border border-grey rounded p-2">
              <div @click="onAppend(inter, 'interface')" class="flex justify-center items-center text-center px-2 py-1" v-for="(inter, index) in server.interfaces" :key="`interface-${index}`">
                <div class="border border-grey rounded p-4 hover:shadow-md hover:bg-purple-dark hover:text-white cursor-pointer duration-1">
                  <p class="font-bold">{{ inter.name }}</p>
                  <img class="w-6" v-if="inter.symbol_off" :src="inter.symbol_off.url" :alt="inter.symbol_off.name">
                </div>
              </div>
              <span v-if="server.interfaces.length === 0" class="text-grey-darkest font-bold">No hay Interfaces de Red</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button warning" @click="$emit('close')">Cerrar</button>
    </div>
  </app-modal>
</template>

<script>
  import AppModal from '../../components/AppModal'
  import DragDrop from '../../components/DragDrop'

  const device = {
    actuators: [],
    sensors: [],
    interfaces: []
  }

  export default {
    name: 'configuration-form',
    props: ['open', 'device'],
    components: {
      AppModal,
      DragDrop
    },
    data: () => ({
      currentDevice: { ...device },
      server: { ...device },
      fixedServer: { ...device },
      saving: false
    }),
    beforeMount() {
      this.fetchActuators()
      this.fetchSensors()
      this.fetchInterfaces()
    },
    methods: {
      onAppend({id}, type = 'sensor') {
        const that = this
        const request = new Object()
        request[`${type}_id`] = id
        this.$axios.put(`/devices/${this.currentDevice.id}/${type}s`, request)
        .then(_ => {
          that.fetchDevice()
        })
        .catch(err => {
          that.$swal({
            type: 'error',
            title: 'Error',
            text: err
          })
        })
      },
      onRemove({id}, type = 'sensor') {
        const that = this
        const request = new Object()
        request[`${type}_id`] = id
        this.$axios.delete(`/devices/${this.currentDevice.id}/${type}s/${id}`)
        .then(_ => {
          that.fetchDevice()
        })
        .catch(err => {
          that.$swal({
            type: 'error',
            title: 'Error',
            text: err
          })
        })
      },
      updateServer() {
        this.server = {
          sensors: this.fixedServer.sensors.filter(sensor => !this.deviceIds.sensors.includes(sensor.id)),
          actuators: this.fixedServer.actuators.filter(actuator => !this.deviceIds.actuators.includes(actuator.id)),
          interfaces: this.fixedServer.interfaces.filter(inter => !this.deviceIds.interfaces.includes(inter.id)),
        }
      },
      fetchDevice() {
        const that = this
        this.$axios.get(`/devices/${this.currentDevice.id}.json`)
        .then(({data}) => {
          that.currentDevice = data.device
          that.updateServer()
        })
        .catch(err =>
          this.$swal({
            type: 'error',
            title: 'Error',
            text: 'No se pudo obtener información del dispositivo. ' + err
          })
        )
      },
      fetchSensors() {
        const that = this
        this.$axios
          .get('/sensors.json')
          .then(({ data }) => {
            that.fixedServer.sensors = data.sensors
          })
          .catch(err =>
            this.$swal({
              type: 'error',
              title: 'Error',
              text: 'No se pudieron obtener los sensores.'
            })
          )
      },
      fetchActuators() {
        const that = this
        this.$axios
          .get('/actuators.json')
          .then(({ data }) => {
            that.fixedServer.actuators = data.actuators
          })
          .catch(err =>
            this.$swal({
              type: 'error',
              title: 'Error',
              text: 'No se pudieron obtener los actuadores.'
            })
          )
      },
      fetchInterfaces() {
        const that = this
        this.$axios
          .get('/interfaces.json')
          .then(({ data }) => {
            that.fixedServer.interfaces = data.interfaces
          })
          .catch(err =>
            this.$swal({
              type: 'error',
              title: 'Error',
              text: 'No se pudieron obtener las interfaces de red.'
            })
          )
      },
    },
    computed: {
      deviceIds() {
        return {
          sensors: this.currentDevice.sensors.map(sensor => sensor.id),
          actuators: this.currentDevice.actuators.map(actuator => actuator.id),
          interfaces: this.currentDevice.interfaces.map(inter => inter.id)
        }
      }
    },
    watch: {
      currentDevice() {
        this.updateServer()
      },
      device() {
        this.currentDevice = this.device
        this.updateServer()
      }
    }
  }
</script>
