<template>
  <div>
    <p class="title text-3xl mb-2">
      Sensores
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="sensors.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Sensores aún, <span @click="addOptions.open = true" class="text-blue cursor-posensor">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Símbolos', 'Nombre', 'Unidad de medición', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in sensors" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4 text-center">
                <img v-if="row.symbol_on" class="w-12" :src="row.symbol_on.url" :alt="row.symbol_on.name">
                <img v-if="row.symbol_off" class="w-12" :src="row.symbol_off.url" :alt="row.symbol_off.name">
                <img v-if="row.symbol_error" class="w-12" :src="row.symbol_error.url" :alt="row.symbol_error.name">
              </td>
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

    <sensor-form
      :open="addOptions.open"
      @fetch="fetchSensors"
      @close="addOptions.open = false"></sensor-form>

    <sensor-form
      :open="editOptions.open"
      :sensor="editOptions.sensor"
      @fetch="fetchSensors"
      @close="editOptions.open = false"></sensor-form>
  </div>
</template>

<script>
import SensorForm from './SensorForm'

export default {
  name: 'sensors',
  data: () => ({
    sensors: [],
    selectedSensor: null,
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      sensor: null
    }
  }),
  components: {
    SensorForm
  },
  beforeMount() {
    this.fetchSensors()
  },
  methods: {
    openEdit: function (sensor) {
      this.editOptions.open = true
      this.editOptions.sensor = sensor
    },
    handleDelete: function (sensor) {
      const that = this
      this.$swal({
        title: `Se eliminará la sensor ${sensor.name}`,
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
          this.$axios.delete(`/sensors/${sensor.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La sensor ${sensor.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchSensors()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la sensor.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchSensors: function () {
      const that = this
      this.$axios.get('/sensors.json')
        .then(({
          data
        }) => {
          that.sensors = data.sensors
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
