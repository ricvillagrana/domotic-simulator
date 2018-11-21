<template>
  <div>
    <p class="title text-3xl mb-2">Pisos <button @click="addOptions.open = true" class="button primary text-sm">Agregar</button></p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="floors.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Pisos aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega uno</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Imagen de fondo', 'Nombre', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in floors" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">
                <img v-if="row.background" class="h-16" :src="row.background.url" :alt="row.background.name">
              </td>
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">
                <div class="flex flex-row">
                  <button @click="handleEdit(row)" class="button warning">Editar</button>
                  <button @click="handleDelete(row)" class="button danger">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="flex flex-col flex-1 mx-4">
        <div v-show="selectedFloor">
          <p class="text-3xl pb-4 font-bold">Habitaciones de {Piso seleccionado}</p>
        </div>
      </div>
    </div>

    <floor-form
      :open="addOptions.open"
      @fetch="fetchFloors"
      @close="addOptions.open = false"></floor-form>
    
    <floor-form
      :open="editOptions.open"
      :floor="editOptions.floor"
      @fetch="fetchFloors"
      @close="editOptions.open = false"></floor-form>
  </div>
</template>

<script>
import FloorForm from './FloorForm'

export default {
  name: 'floors',
  data: () => ({
    floors: [],
    selectedFloor: null,
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      floor: null
    }
  }),
  mounted () {
    this.fetchFloors()
  },
  components: { FloorForm },
  methods: {
    handleEdit (floor) {
      this.editOptions.floor = floor
      this.editOptions.open = true
    },
    handleDelete: function (floor) {
      const that = this
      this.$swal({
        title: `Se eliminará el piso ${floor.name}`,
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
          this.$axios.delete(`/floors/${floor.id}`)
          .then(({data}) => {
            if (data.status == 200) {
              that.$swal({
                type: 'success',
                title: 'Elminado',
                text: `El piso ${floor.name} se eliminó de manera correcta.`,
              })
            }
            that.fetchFloors()
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error',
              text: 'No se pudo eliminar el piso.',
              footer: `Error: ${err}`
            })
          })
        }
      })
    },
    fetchFloors: function () {
      const that = this
      this.$axios.get('/floors.json')
        .then(({data}) => {
          that.floors = data.floors
        })
    }
  }
}
</script>
