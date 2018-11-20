<template>
  <div>
    <p class="title text-3xl mb-2">
      Actuatores
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="actuators.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Actuatores aún, <span @click="addOptions.open = true" class="text-blue cursor-poactuator">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Nombre', 'Unidad de medición', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in actuators" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.unit_type.symbol }} - {{ row.unit_type.unit }}</td>
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
    
    <actuator-form
      :open="addOptions.open"
      @fetch="fetchActuators"
      @close="addOptions.open = false"></actuator-form>
    
    <actuator-form
      :open="editOptions.open"
      :actuator="editOptions.actuator"
      @fetch="fetchActuators"
      @close="editOptions.open = false"></actuator-form>
  </div>
</template>

<script>
import ActuatorForm from './ActuatorForm'

export default {
  name: 'actuators',
  data: () => ({
    actuators: [],
    selectedActuator: null,
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      actuator: null
    }
  }),
  components: {
    ActuatorForm
  },
  beforeMount() {
    this.fetchActuators()
  },
  methods: {
    openEdit: function (actuator) {
      this.editOptions.open = true
      this.editOptions.actuator = actuator
    },
    handleDelete: function (actuator) {
      const that = this
      this.$swal({
        title: `Se eliminará la actuatorfaz ${actuator.name}`,
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
          this.$axios.delete(`/actuators/${actuator.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La actuatorfaz ${actuator.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchActuators()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la actuatorfaz.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchActuators: function () {
      const that = this
      this.$axios.get('/actuators.json')
        .then(({
          data
        }) => {
          that.actuators = data.actuators
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
