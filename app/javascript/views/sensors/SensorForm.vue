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

        <label for="environment" class="label">Variable de ambiente:</label>
        <select name="environment" class="input bg-white" :class="{ 'error' : errors.environment_id }" v-model="currentSensor.environment_id">
          <option value="0" disabled selected> - Selecciona una - </option>
          <option v-for="(env, key) in envs" :key="`unit-${key}`" :value="env.id">{{ env.name }}</option>
        </select>
        <span class="input-error-message" v-show="errors.environment_id">{{ errors.environment_id }}</span>

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
        environment_id: 0,
        ...symbols
      },
      errors: {
        name: null,
        environment_id: null
      },
      ready: { ...symbols },
      blobs: { ...symbols },
      saving: false,
      envs: []
    }),
    beforeMount() {
      this.fetchEnvironments()
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
              ...that.currentSensor,
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
              ...that.currentSensor,
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
      fetchEnvironments() {
        const that = this
        this.$axios
          .get('/environments.json')
          .then(({ data }) => {
            that.envs = data.environments
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
        this.errors.environment_id = null

        if (this.currentSensor.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
        if (this.currentSensor.environment_id <= 0 || this.currentSensor.environment_id === null)
          this.errors.environment_id = 'Unidad de medición inválida, selecciona una.'

        return this.errors.name || this.errors.environment_id
      }
    },
    watch: {
      sensor() {
        this.fetchEnvironments()
        if (this.sensor) {
          this.currentSensor = {
            ...symbols,
            ...this.sensor
          }
        } else {
          this.currentSensor = {
            name: '',
            description: '',
            environment_id: 0,
            ...symbols
          }
        }
        this.ready = { ...symbols }
        this.blobs = { ...symbols }
      }
    }
  }
</script>
