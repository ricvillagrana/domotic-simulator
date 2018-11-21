<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ sensor ? currentSensor.name : 'Nuevo Sensor' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre del sensor:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre del sensor" v-model="currentSensor.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="unit_type" class="label">Unidad de medición:</label>
        <select name="unit_type" class="input bg-white" :class="{ 'error' : errors.unit_type_id }" v-model="currentSensor.unit_type_id">
              <option value="0" disabled selected> - Selecciona una unidad de medición - </option>

          <option v-for="(unit, key) in unitTypes" :key="`unit-${key}`" :value="unit.id">{{ unit.unit }}</option>
        </select>
        <span class="input-error-message" v-show="errors.unit_type_id">{{ errors.unit_type_id }}</span>

      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button danger" @click="$emit('close')">Cancelar</button>
      <button @click="handleSave" class="button success" :class="{ 'disabled' : invalid }" :disabled="invalid || saving"><i v-show="saving" class="fa fa-spinner spin"></i>Guardar</button>
    </div>
  </app-modal>
</template>

<script>
import AppModal from '../../components/AppModal'

export default {
  name: 'sensor-form',
  props: ['open', 'sensor'],
  components: {
    AppModal
  },
  data: () => ({
    currentSensor: {
      name: '',
      unit_type_id: 0
    },
    errors: {
      name: null,
      unit_type_id: null
    },
    saving: false,
    unitTypes: []
  }),
  beforeMount () {
    this.fetchUnits()
  },
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (this.sensor) {
        this.$axios.put(`/sensors/${this.sensor.id}`, {
          ...that.currentSensor
        })
          .then(({data}) => {
            that.saving = false
            that.$swal.close()
            that.$emit('close')
            that.$emit('fetch')
          }).catch(err => {
            console.log(err)
          })
      } else {
        that.$axios.post('/sensors', {
          ...that.currentSensor
        })
          .then(result => {
            that.currentSensor = {
              name: '',
              description: '',
              unit_type_id: 0
            }
            that.saving = false
            that.$swal.close()
            that.$emit('close')
            that.$emit('fetch')
          })
          .catch(err => {
            that.$swal({
              type: 'error',
              title: 'Error en el servidor',
              text: err
            })
            that.saving = false
          })
      }
    },
    fetchUnits: function () {
      const that = this
      this.$axios.get('/unit_types.json')
        .then(({
          data
        }) => {
          that.unitTypes = data.unit_types
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
  computed: {
    invalid () {
      this.errors.name = null
      this.errors.unit_type_id = null

      if (this.currentSensor.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
      if (this.currentSensor.unit_type_id <= 0 || this.currentSensor.unit_type_id === null) this.errors.unit_type_id = 'Unidad de medición inválida, selecciona una.'

      return this.errors.name || this.errors.unit_type_id
    }
  },
  watch: {
    sensor: function () {
      this.fetchUnits()
      if (this.sensor) {
        this.currentSensor = {
          name: this.sensor.name,
          description: this.sensor.description,
          unit_type_id: this.sensor.unit_type_id
        }
      } else {
        this.currentSensor = {
          name: '',
          description: '',
          unit_type_id: 0
        }
      }
    }
  }
}
</script>