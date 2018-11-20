<template>
  <div>
    <p class="title text-3xl mb-2">
      Unidades de medición
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="units.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Unidades de medición aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Nombre', 'Descripción', 'Símbolo', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in units" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.unit }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.symbol }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.description.substr(0, 100) }}...</td>
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
    
    <unit-type-form
      :open="addOptions.open"
      @fetch="fetchUnitTypes"
      @close="addOptions.open = false"></unit-type-form>
    
    <unit-type-form
      :open="editOptions.open"
      :unit="editOptions.unit"
      @fetch="fetchUnitTypes"
      @close="editOptions.open = false"></unit-type-form>
  </div>
</template>

<script>
import UnitTypeForm from './UnitTypeForm'

export default {
  name: 'interfaces',
  data: () => ({
    units: [],
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      unit: null
    }
  }),
  components: {
    UnitTypeForm
  },
  beforeMount() {
    this.fetchUnitTypes()
  },
  methods: {
    openEdit: function (unit) {
      this.editOptions.open = true
      this.editOptions.unit = unit
    },
    handleDelete: function (unit) {
      const that = this
      this.$swal({
        title: `Se eliminará la unidad de medición ${unit.name}`,
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
          this.$axios.delete(`/unit_types/${unit.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La unidad de medicón ${unit.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchUnitTypes()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la unidad de medición.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchUnitTypes: function () {
      const that = this
      this.$axios.get('/unit_types.json')
        .then(({
          data
        }) => {
          that.units = data.unit_types
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
