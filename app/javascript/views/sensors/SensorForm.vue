<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ sensor ? currentSensor.name : 'Nuevo Sensor' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre del sensor:</label>
        <input type="text"
               name="name"
               class="input"
               :class="{ 'error' : errors.name }"
               placeholder="Nombre del sensor"
               v-model="currentSensor.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="unit_type" class="label">Unidad de medición:</label>
        <select name="unit_type" class="input bg-white" :class="{ 'error' : errors.unit_type_id }" v-model="currentSensor.unit_type_id">
          <option value="0" disabled selected> - Selecciona una unidad de medición - </option>
          <option v-for="(unit, key) in unitTypes" :key="`unit-${key}`" :value="unit.id">{{ unit.unit }}</option>
        </select>
        <span class="input-error-message" v-show="errors.unit_type_id">{{ errors.unit_type_id }}</span>

        <label for="symbols" class="label">Símbolos:</label>
        <div class="flex flex-row">
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Apagado:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentSensor.symbol_off" class="image-preview" :src="currentSensor.symbol_off.url" :alt="currentSensor.symbol_off.name">
            </div>
            <drag-drop @images="currentSensor.symbol_off = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Encendido:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentSensor.symbol_on" class="image-preview" :src="currentSensor.symbol_on.url" :alt="currentSensor.symbol_on.name">
            </div>
            <drag-drop @images="currentSensor.symbol_on = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Descompuesto:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentSensor.symbol_error" class="image-preview" :src="currentSensor.symbol_error.url" :alt="currentSensor.symbol_error.name">
            </div>
            <drag-drop @images="currentSensor.symbol_error = $event[0]"></drag-drop>
          </div>
        </div>
      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button danger" @click="$emit('close')">Cancelar</button>
      <button @click="makeBlobs"
              class="button success"
              :class="{ 'disabled' : invalid }"
              :disabled="invalid || saving"><i v-show="saving" class="fa fa-spinner spin"></i>Guardar</button>
    </div>
  </app-modal>
</template>

<script>
  import AppModal from '../../components/AppModal'
  import DragDrop from '../../components/DragDrop'

  const symbols = {
    symbol_off: null,
    symbol_on: null,
    symbol_error: null
  }

  export default {
    name: 'sensor-form',
    props: ['open', 'sensor'],
    components: {
      AppModal,
      DragDrop
    },
    data: () => ({
      currentSensor: {
        name: '',
        unit_type_id: 0,
        ...symbols
      },
      errors: {
        name: null,
        unit_type_id: null
      },
      ready: { ...symbols },
      blobs: { ...symbols },
      saving: false,
      unitTypes: []
    }),
    beforeMount() {
      this.fetchUnits()
    },
    methods: {
      makeBlobs() {
        this.saving = true
        const that = this
        if (that.currentSensor.symbol_off || that.currentSensor.symbol_on || that.currentSensor.symbol_error)
          this.$swal({
            title: 'Subiendo imagen(es)...',
            text: 'Espera, por favor...',
            onOpen: () => that.$swal.showLoading()
          })
        if (that.currentSensor.symbol_off && that.currentSensor.symbol_off.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentSensor.symbol_off.raw,
            '/rails/active_storage/direct_uploads'
          )
          upload.create((error, blob) => {
            if (error) console.log(error)
            else {
              that.blobs.symbol_off = blob
              that.ready.symbol_off = true
              if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
            }
          })
        } else that.ready.symbol_off = true
        if (that.currentSensor.symbol_on && that.currentSensor.symbol_on.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentSensor.symbol_on.raw,
            '/rails/active_storage/direct_uploads'
          )
          upload.create((error, blob) => {
            if (error) console.log(error)
            else {
              that.blobs.symbol_on = blob
              that.ready.symbol_on = true
              if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
            }
          })
        } else that.ready.symbol_on = true
        if (that.currentSensor.symbol_error && that.currentSensor.symbol_error.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentSensor.symbol_error.raw,
            '/rails/active_storage/direct_uploads'
          )
          upload.create((error, blob) => {
            if (error) console.log(error)
            else {
              that.blobs.symbol_error = blob
              that.ready.symbol_error = true
              if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
            }
          })
        } else that.ready.symbol_error = true
        if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
      },
      handleSave() {
        const that = this
        if (this.sensor) {
          this.$axios
            .put(`/sensors/${this.sensor.id}`, {
              name: that.currentSensor.name,
              description: that.currentSensor.description,
              blobs: that.blobs
            })
            .then(({ data }) => {
              that.saving = false
              that.$swal.close()
              that.$emit('close')
              that.$emit('fetch')
              that.ready = {
                symbol_off: false,
                symbol_on: false,
                symbol_error: false
              }
            })
            .catch(err => {
              console.log(err)
            })
        } else {
          that.$axios
            .post('/sensors', {
              name: that.currentSensor.name,
              description: that.currentSensor.description,
              blobs: that.blobs
            })
            .then(result => {
              that.currentSensor = {
                name: '',
                description: '',
                ...symbols
              }
              that.ready = {
                symbol_off: false,
                symbol_on: false,
                symbol_error: false
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
      fetchUnits() {
        const that = this
        this.$axios
          .get('/unit_types.json')
          .then(({ data }) => {
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
      invalid() {
        this.errors.name = null
        this.errors.unit_type_id = null

        if (this.currentSensor.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
        if (this.currentSensor.unit_type_id <= 0 || this.currentSensor.unit_type_id === null)
          this.errors.unit_type_id = 'Unidad de medición inválida, selecciona una.'

        return this.errors.name || this.errors.unit_type_id
      }
    },
    watch: {
      sensor() {
        this.fetchUnits()
        if (this.sensor) {
          this.currentSensor = {
            ...symbols,
            ...this.sensor
          }
        } else {
          this.currentSensor = {
            name: '',
            description: '',
            unit_type_id: 0,
            ...symbols
          }
        }
      }
    }
  }
</script>
