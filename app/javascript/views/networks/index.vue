<template>
  <div>
    <p class="text-3xl pb-4 font-bold">
      Redes
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1 mx-4">
        <div v-if="networks.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Redes aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Nombre', 'Descripción', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in networks" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.description.substr(0, 50) }}...</td>
              <td class="border border-grey-light py-2 px-4">
                <div class="flex flex-row">
                  <button @click="openEdit(row)" class="button warning">Editar</button>
                  <button @click="handleDelete(row)" class="button danger">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="flex flex-col flex-1 mx-4">
        <div v-show="selectedNetwork">
          <p class="text-3xl pb-4 font-bold">Habitaciones de {Piso seleccionado}</p>
        </div>
      </div>
    </div>
    
      <network-form
        :open="addOptions.open"
        @fetch="fetchNetworks"
        @close="addOptions.open = false"></network-form>
      
      <network-form
        :open="editOptions.open"
        :network="editOptions.network"
        @fetch="fetchNetworks"
        @close="editOptions.open = false"></network-form>
  </div>
</template>

<script>
import NetworkForm from './NetworkForm'

export default {
  name: 'networks',
  data: () => ({
    networks: [],
    selectedNetwork: null,
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      network: null
    }
  }),
  components: {
    NetworkForm
  },
  beforeMount() {
    this.fetchNetworks()
  },
  methods: {
    openEdit: function (network) {
      this.editOptions.open = true
      this.editOptions.network = network
    },
    handleDelete: function (network) {
      const that = this
      this.$swal({
        title: `Se eliminará la red ${network.name}`,
        text: "No se podrá recuprar",
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Eliminar',
        cancelButtonText: 'No, cancelar',
        cancelButtonColor: 'red',
        reverseButtons: true
      }).then((result) => {
        if (result.value) {
          this.$swal({
            title: 'Eliminando...',
            onOpen: () => that.$swal.showLoading()
          })
          this.$axios.delete(`/networks/${network.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La red ${network.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchNetworks()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la red.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchNetworks: function () {
      const that = this
      this.$axios.get('/networks.json')
        .then(({
          data
        }) => {
          that.networks = data.networks
        })
        .catch(err => {
          that.$swal({
            type: 'error',
            title: 'Error',
            text: err
          })
        })
    }
  }
}
</script>
