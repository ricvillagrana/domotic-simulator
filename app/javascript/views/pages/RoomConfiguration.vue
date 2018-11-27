<template>
  <app-modal v-if="currentRoom" class="max-h-screen text-grey-darker" :open="open" @close="$emit('close')" :size="'3/5'">
    <div slot="header">
      Configurando {{ currentRoom.name }}
    </div>
    <div slot="content" class="h-96">
      <div class="flex flex-col w-full h-full">
        <div class="flex flex-row">
          <span v-for="(item, index) in options" :key="`option-${index}`"
          @click="selectedOption = item.id"
          class="flex w-1/2 justify-center border border-b-0 border-blue-dark rounded-t cursor-pointer font-bold duration-2 py-4"
          :class="item.id === selectedOption ? 'text-blue py-2 self-end' : 'text-white bg-blue-dark hover:bg-blue-dark'">
            {{ item.name }}
          </span>
        </div>
        <div class="flex flex-col border border-t-0 border-blue-dark rounded-b p-2 h-full">
          <div v-if="selectedOption === 1" class="flex flex-col w-full">
            <p class="text-xl text-blue-dark">Selecciona las variables que quieres activar.</p>
            <div class="flex flex-row flex-wrap overflow-scroll">
              <span v-for="(env, index) in environments" :key="`env-${index}`"
                @click="toggleEnvironment(env)"
                class="rounded p-4 m-2 hover:shadow-md border border-blue cursor-pointer duration-1"
                :class="isActiveEnvironment(env) ? 'bg-blue-dark text-white' :  'text-blue'">
                {{ env.name }}
              </span>
              <span v-show="environments.length === 0">No hay ninguna disponible.</span>
            </div>
          </div>
          <div v-if="selectedOption === 2" class="flex flex-col w-full">
            <p class="text-xl text-blue-dark">Selecciona los dispositivos que quieres activar.</p>
            <div class="flex flex-row flex-wrap overflow-scroll">
              <span v-for="(device, index) in devices" :key="`device-${index}`"
                @click="toggleDevice(device)"
                class="rounded p-4 m-2 hover:shadow-md border border-blue cursor-pointer duration-1"
                :class="isActiveDevice(device) ? 'bg-blue-dark text-white' :  'text-blue'">
                {{ device.name }}
              </span>
              <span v-show="devices.length === 0">No hay ninguno disponible, selecciona más <span class="cursor-pointer text-blue" @click="selectedOption = 1">variables de ambiente</span> para habilitar los dispositivos.</span>
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

  export default {
    name: 'room-configuration',
    props: ['open', 'room'],
    components: {
      AppModal
    },
    data: () => ({
      currentRoom: null,
      devices: [],
      environments: [],
      saving: false,
      options: [
        {
          id: 1,
          name: 'Variables de ambiente'
        },
        {
          id: 2,
          name: 'Dispositivos'
        }
      ],
      selectedOption: 1
    }),
    beforeMount() {
      this.fetchEnvironments()
    },
    methods: {
      toggleEnvironment(env) {
        const that = this
        const {id} = env
        // this.$swal.showLoading()
        if (this.isActiveEnvironment(env)) {
          this.$axios.delete(`/rooms/${this.currentRoom.id}/remove_environment/${id}`)
          .then(_ => {
            that.fetchRoom()
            that.fetchDevices()
            that.$swal.close()
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error',
              text: err
            })
          })
        } else {
          this.$axios.put(`/rooms/${this.currentRoom.id}/append_environment/${id}`)
          .then(_ => {
            that.fetchRoom()
            that.fetchDevices()
            that.$swal.close()
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error',
              text: err
            })
          })
        }
      },
      toggleDevice(device) {
        const that = this
        const {id} = device
        // this.$swal.showLoading()
        if (this.isActiveDevice(device)) {
          this.$axios.delete(`/rooms/${this.currentRoom.id}/remove_device/${id}`)
          .then(_ => {
            that.fetchRoom()
            this.fetchDevices()
            that.$swal.close()
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error',
              text: err
            })
          })
        } else {
          this.$axios.put(`/rooms/${this.currentRoom.id}/append_device/${id}`)
          .then(_ => {
            that.fetchRoom()
            this.fetchDevices()
            that.$swal.close()
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error',
              text: err
            })
          })
        }
      },
      isActiveEnvironment({id}) {
        return this.currentRoom.environments.filter(env => env.id === id).length > 0
      },
      isActiveDevice({id}) {
        return this.currentRoom.devices.filter(env => env.id === id).length > 0
      },
      fetchDevices() {
        const that = this
        this.$axios.get(`/rooms/${this.room.id}/devices.json`)
        .then(({data}) => {
          that.devices = data.devices
        })
        .catch(err =>
          this.$swal({
            type: 'error',
            title: 'Error',
            text: 'No se pudo obtener información del dispositivo. ' + err
          })
        )
      },
      fetchEnvironments() {
        const that = this
        this.$axios.get(`/environments.json`)
        .then(({data}) => {
          that.environments = data.environments
        })
        .catch(err =>
          this.$swal({
            type: 'error',
            title: 'Error',
            text: 'No se pudieron obtener las variables de ambiente. ' + err
          })
        )
      },
      fetchRoom() {
        const that = this
        this.$axios.get(`/rooms/${this.room.id}.json`)
        .then(({data}) => {
          that.currentRoom = data.room
        })
        .catch(err =>
          this.$swal({
            type: 'error',
            title: 'Error',
            text: 'No se pudieron obtener los datos de la habitación. ' + err
          })
        )
      }
    },
    computed: {},
    watch: {
      room() {
        if (this.room.id) {
          this.fetchRoom()
          this.fetchDevices()
        }
      }
    }
  }
</script>
