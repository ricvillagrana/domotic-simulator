<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ device ? currentDevice.name : 'Nueva dispositivo' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre del dispositivo:</label>
        <input type="text"
               name="name"
               class="input"
               :class="{ 'error' : errors.name }"
               placeholder="Nombre del dispositivo. Ej. Aire acondicionado"
               v-model="currentDevice.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description"
                  class="textarea"
                  :class="{ 'error' : errors.description }"
                  placeholder="Descripción"
                  v-model="currentDevice.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

        <label for="device_type_id" class="label">Tipo de dispositivo:</label>
        <select name="device_type_id" class="input bg-white" :class="{ 'error' : errors.device_type_id }" v-model="currentDevice.device_type_id">
          <option value="0" disabled selected> - Selecciona un tipo de dispositivo - </option>
          <option v-for="(device_type, key) in device_types" :key="`device_type-${key}`" :value="device_type.id">{{ device_type.name }}</option>
        </select>
        <span class="input-error-message" v-show="errors.device_type_id">{{ errors.device_type_id }}</span>

        <label for="description" class="label">Imagen del dispositivo:</label>
        <div class="flex flex-row justify-center mb-2">
          <img v-if="currentDevice.image" class="image-preview" :src="currentDevice.image.url" :alt="currentDevice.image.name">
        </div>
        <drag-drop @images="currentDevice.image = $event[0]"></drag-drop>

      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button danger" @click="$emit('close')">Cancelar</button>
      <button @click="handleSave"
              class="button success"
              :class="{ 'disabled' : invalid }"
              :disabled="invalid || saving"><i v-show="saving" class="fa fa-spinner spin"></i>Guardar</button>
    </div>
  </app-modal>
</template>

<script>
  import AppModal from '../../components/AppModal'
  import DragDrop from '../../components/DragDrop'

  export default {
    name: 'device-form',
    props: ['open', 'device'],
    components: {
      AppModal,
      DragDrop
    },
    data: () => ({
      currentDevice: {
        name: '',
        description: '',
        image: null,
        device_type_id: 0
      },
      errors: {
        name: null,
        description: null,
        device_type_id: null
      },
      device_types: [],
      saving: false
    }),
    beforeMount() {
      this.fetchDeviceTypes()
    },
    methods: {
      handleSave() {
        this.saving = true
        const that = this
        if (that.currentDevice.image)
          this.$swal({
            title: 'Subiendo imagen(es)...',
            text: 'Espera, por favor...',
            onOpen: () => that.$swal.showLoading()
          })
        if (that.currentDevice.image && that.currentDevice.image.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentDevice.image.raw,
            '/rails/active_storage/direct_uploads'
          )
          upload.create((error, blob) => {
            if (error) console.log(error)
            else {
              const device = {
                name: that.currentDevice.name,
                description: that.currentDevice.description,
                device_type_id: that.currentDevice.device_type_id,
                image: blob
              }
              if (this.device) {
                this.$axios
                  .put(`/devices/${this.device.id}`, device)
                  .then(({ data }) => {
                    that.saving = false
                    that.$swal.close()
                    that.$emit('close')
                    that.$emit('fetch')
                  })
                  .catch(err => {
                    console.log(err)
                  })
              } else {
                that.$axios
                  .post('/devices', device)
                  .then(result => {
                    that.saved(result)
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
            }
          })
        } else {
          const device = {
            name: that.currentDevice.name,
            description: that.currentDevice.description,
            device_type_id: that.currentDevice.device_type_id
          }
          if (this.device) {
            this.$axios
              .put(`/devices/${this.device.id}`, device)
              .then(({ data }) => {
                that.saving = false
                that.$swal.close()
                that.$emit('close')
                that.$emit('fetch')
              })
              .catch(err => {
                console.log(err)
              })
          } else {
            that.$axios
              .post('/devices', device)
              .then(result => {
                that.saved(result)
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
        }
      },
      saved(result) {
        const that = this
        if (result.data.status === 200) {
          that.currentDevice = {
            name: '',
            description: '',
            image: null,
            device_type_id: 0
          }
          that.saving = false
          that.$swal.close()
          that.$emit('close')
          that.$emit('fetch')
        } else {
          that.$swal({
            type: 'error',
            title: 'Error en el servidor',
            text: 'Debe tener un tipo de dispositivo.'
          })
          that.saving = false
        }
      },
      fetchDeviceTypes() {
        const that = this
        this.$axios.get('/device_types.json')
          .then(({data}) => {
            that.device_types = data.device_types
          })
          .catch(err => this.$swal({
            type: 'error',
            title: 'Error',
            text: 'No se pudieron obtener los tipos de dispositivo.'
          }))
      }
    },
    computed: {
      invalid() {
        this.errors.name = null
        this.errors.description = null
        this.errors.device_type_id = null

        if (this.currentDevice.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
        if (this.currentDevice.device_type_id === 0) this.errors.device_type_id = 'Tipo de dispositivo inválido, elige uno.'
        if (this.currentDevice.description.length < 30) this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${this.currentDevice.description.length}.`

        return this.errors.name || this.errors.description || this.errors.device_type_id
      }
    },
    watch: {
      device() {
        this.currentDevice = {
          name: '',
          description: '',
          image: null,
          device_type_id: 0
        }
        if (this.device) {
          this.currentDevice = {
            ...this.currentDevice,
            ...this.device
          }
        }
      }
    }
  }
</script>
