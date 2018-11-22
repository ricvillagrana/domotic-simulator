<template>
  <div>
    <p class="title text-3xl mb-2">Dispositivos <button @click="addOptions.open = true" class="button primary text-sm">Agregar</button></p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="devices.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Dispositivos aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega uno</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th v-for="(header, key) in ['Imagen de fondo', 'Nombre', 'Descripción', 'Tipo', 'Acciones']"
                  class="border-b-2 border border-grey-light py-2 px-8"
                  :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in devices" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">
                <img v-if="row.image" class="h-16" :src="row.image.url" :alt="row.image.name">
              </td>
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.description }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.device_type.name }}</td>
              <td class="border border-grey-light py-2 px-4">
                <div class="flex flex-row">
                  <button @click="selected = row" class="button primary">Detalles</button>
                  <button @click="handleEdit(row)" class="button warning">Editar</button>
                  <button @click="handleDelete(row)" class="button danger">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <device-form :open="addOptions.open"
                 @fetch="fetchDevices"
                 @close="addOptions.open = false"></device-form>

    <device-form :open="editOptions.open"
                 :device="editOptions.device"
                 @fetch="fetchDevices"
                 @close="editOptions.open = false"></device-form>
  </div>
</template>

<script>
  import DeviceForm from './DeviceForm'

  export default {
    name: 'devices',
    data: () => ({
      devices: [],
      selected: null,
      addOptions: {
        open: false
      },
      editOptions: {
        open: false,
        device: null
      }
    }),
    mounted() {
      this.fetchDevices()
    },
    components: { DeviceForm },
    methods: {
      handleEdit(device) {
        this.editOptions.device = device
        this.editOptions.open = true
      },
      handleDelete(device) {
        const that = this
        this.$swal({
          title: `Se eliminará el dispositivo ${device.name}`,
          text: 'No se podrá recuprar',
          type: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Eliminar',
          cancelButtonText: 'No, cancelar',
          cancelButtonColor: 'red',
          reverseButtons: true
        }).then(result => {
          if (result.value) {
            this.$swal({
              title: 'Eliminando...',
              onOpen: () => that.$swal.showLoading()
            })
            this.$axios
              .delete(`/devices/${device.id}`)
              .then(({ data }) => {
                if (data.status == 200) {
                  that.$swal({
                    type: 'success',
                    title: 'Elminado',
                    text: `El dispositivo ${device.name} se eliminó de manera correcta.`
                  })
                }
                that.fetchDevices()
              })
              .catch(err => {
                that.$swal({
                  type: 'error',
                  title: 'Error',
                  text: 'No se pudo eliminar el dispositivo.',
                  footer: `Error: ${err}`
                })
              })
          }
        })
      },
      fetchDevices() {
        const that = this
        this.$axios.get('/devices.json').then(({ data }) => {
          that.devices = data.devices
        })
      }
    }
  }
</script>
