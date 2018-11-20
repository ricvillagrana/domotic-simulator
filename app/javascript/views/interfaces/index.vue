<template>
  <div>
    <p class="title text-3xl mb-2">
      Interfaces de red
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="interfaces.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Interfaces de red aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Nombre', 'Descripción', 'Tipo de Red', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in interfaces" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.description.substr(0, 100) }}...</td>
              <td class="border border-grey-light py-2 px-4">{{ row.network.name }}</td>
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
    </div>
    
    <interface-form
      :open="addOptions.open"
      @fetch="fetchInterfaces"
      @close="addOptions.open = false"></interface-form>
    
    <interface-form
      :open="editOptions.open"
      :inter="editOptions.inter"
      @fetch="fetchInterfaces"
      @close="editOptions.open = false"></interface-form>
  </div>
</template>

<script>
import InterfaceForm from './InterfaceForm'

export default {
  name: 'interfaces',
  data: () => ({
    interfaces: [],
    selectedInterface: null,
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      inter: null
    }
  }),
  components: {
    InterfaceForm
  },
  beforeMount() {
    this.fetchInterfaces()
  },
  methods: {
    openEdit: function (inter) {
      this.editOptions.open = true
      this.editOptions.inter = inter
    },
    handleDelete: function (inter) {
      const that = this
      this.$swal({
        title: `Se eliminará la interfaz ${inter.name}`,
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
          this.$axios.delete(`/interfaces/${inter.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La interfaz ${inter.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchInterfaces()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la interfaz.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchInterfaces: function () {
      const that = this
      this.$axios.get('/interfaces.json')
        .then(({
          data
        }) => {
          that.interfaces = data.interfaces
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
