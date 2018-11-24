<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ inter ? currentInterface.name : 'Nueva Interfaz de Red' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre de la interfaz:</label>
        <input type="text"
               name="name"
               class="input"
               :class="{ 'error' : errors.name }"
               placeholder="Nombre de la red"
               v-model="currentInterface.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description"
                  class="textarea"
                  :class="{ 'error' : errors.description }"
                  placeholder="Descripción"
                  v-model="currentInterface.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

        <label for="description" class="label">Red:</label>
        <select name="network_id" class="input bg-white" :class="{ 'error' : errors.network_id }" v-model="currentInterface.network_id">
                <option value="0" disabled selected> - Selecciona una red - </option>
                <option v-for="(network, key) in networks" :key="`network-${key}`" :value="network.id">{{ network.name }}</option>
              </select>
        <span class="input-error-message" v-show="errors.network_id">{{ errors.network_id }}</span>

        <label for="symbols" class="label">Símbolos:</label>
        <div class="flex flex-row">
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Apagado:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentInterface.symbol_off" class="image-preview" :src="currentInterface.symbol_off.url" :alt="currentInterface.symbol_off.name">
            </div>
            <drag-drop @images="currentInterface.symbol_off = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Encendido:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentInterface.symbol_on" class="image-preview" :src="currentInterface.symbol_on.url" :alt="currentInterface.symbol_on.name">
            </div>
            <drag-drop @images="currentInterface.symbol_on = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Descompuesto:</label>
            <div class="flex flex-row justify-center mb-2">
              <img v-if="currentInterface.symbol_error" class="image-preview" :src="currentInterface.symbol_error.url" :alt="currentInterface.symbol_error.name">
            </div>
            <drag-drop @images="currentInterface.symbol_error = $event[0]"></drag-drop>
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
    name: 'interface-form',
    props: ['open', 'inter'],
    components: {
      AppModal,
      DragDrop
    },
    data: () => ({
      currentInterface: {
        name: '',
        description: '',
        network_id: 0,
        ...symbols
      },
      ready: { ...symbols },
      blobs: { ...symbols },
      errors: {
        name: null,
        description: null
      },
      saving: false,
      networks: []
    }),
    beforeMount() {
      this.fetchNetworks()
    },
    methods: {
      makeBlobs() {
        this.saving = true
        const that = this
        if (that.currentInterface.symbol_off || that.currentInterface.symbol_on || that.currentInterface.symbol_error)
          this.$swal({
            title: 'Subiendo imagen(es)...',
            text: 'Espera, por favor...',
            onOpen: () => that.$swal.showLoading()
          })
        if (that.currentInterface.symbol_off && that.currentInterface.symbol_off.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentInterface.symbol_off.raw,
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
        if (that.currentInterface.symbol_on && that.currentInterface.symbol_on.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentInterface.symbol_on.raw,
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
        if (that.currentInterface.symbol_error && that.currentInterface.symbol_error.raw) {
          const upload = new ActiveStorage.DirectUpload(
            that.currentInterface.symbol_error.raw,
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
        if (this.inter) {
          this.$axios
            .put(`/interfaces/${this.inter.id}`, {
              name: that.currentInterface.name,
              description: that.currentInterface.description,
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
            .post('/interfaces', {
              name: that.currentInterface.name,
              description: that.currentInterface.description,
              blobs: that.blobs
            })
            .then(result => {
              that.currentInterface = {
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
      fetchNetworks: function() {
        const that = this
        this.$axios
          .get('/networks.json')
          .then(({ data }) => {
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
    },
    computed: {
      invalid() {
        this.errors.name = null
        this.errors.description = null
        this.errors.network_id = null

        if (this.currentInterface.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
        if (this.currentInterface.network_id <= 0 || this.currentInterface.network_id === null)
          this.errors.network_id = 'Red inválida, selecciona una.'
        if (this.currentInterface.description.length < 30)
          this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${
            this.currentInterface.description.length
          }.`

        return this.errors.name || this.errors.description || this.errors.network_id
      }
    },
    watch: {
      inter: function() {
        this.fetchNetworks()
        if (this.inter) {
          this.currentInterface = {
            ...symbols,
            name: this.inter.name,
            description: this.inter.description,
            network_id: this.inter.network_id
          }
        } else {
          this.currentInterface = {
            name: '',
            description: '',
            network_id: 0,
            ...symbols
          }
        }
        this.ready = { ...symbols }
        this.blobs = { ...symbols }
      }
    }
  }
</script>
