<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ network ? currentNetwork.name : 'Nueva Red' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre de la red:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre de la red" v-model="currentNetwork.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description" class="textarea" :class="{ 'error' : errors.description }" placeholder="Descripción" v-model="currentNetwork.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>


        <label for="description" class="label">Símbolos:</label>
        <div class="flex flex-row">
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Apagado:</label>
            <div class="flex flex-row justify-center">
              <img v-if="currentNetwork.symbol_off" class="image-preview" :src="currentNetwork.symbol_off.url" :alt="currentNetwork.symbol_off.name">
            </div>
            <drag-drop
              @images="currentNetwork.symbol_off = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Encendido:</label>
            <div class="flex flex-row justify-center">
              <img v-if="currentNetwork.symbol_on" class="image-preview" :src="currentNetwork.symbol_on.url" :alt="currentNetwork.symbol_on.name">
            </div>
            <drag-drop
              @images="currentNetwork.symbol_on = $event[0]"></drag-drop>
          </div>
          <div class="flex flex-col flex-1 w-1/3 px-1">
            <label for="description" class="label">Descompuesto:</label>
            <div class="flex flex-row justify-center">
              <img v-if="currentNetwork.symbol_error" class="image-preview" :src="currentNetwork.symbol_error.url" :alt="currentNetwork.symbol_error.name">
            </div>
            <drag-drop
              @images="currentNetwork.symbol_error = $event[0]"></drag-drop>
          </div>
        </div>

      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button danger" @click="$emit('close')">Cancelar</button>
      <button @click="makeBlobs" class="button success" :class="{ 'disabled' : invalid }" :disabled="invalid || saving"><i v-show="saving" class="fa fa-spinner spin"></i>Guardar</button>
    </div>
  </app-modal>
</template>

<script>
import AppModal from '../../components/AppModal'
import DragDrop from '../../components/DragDrop'

export default {
  name: 'network-form',
  props: ['open', 'network'],
  components: {
    AppModal, DragDrop
  },
  data: () => ({
    currentNetwork: {
      name: '',
      description: '',
      symbol_off:   null,
      symbol_on:    null,
      symbol_error: null
    },
    errors: {
      name: null,
      description: null
    },
    saving: false,
    blobs: {
      symbol_off:   null,
      symbol_on:    null,
      symbol_error: null
    },
    ready: {
      symbol_off:   false,
      symbol_on:    false,
      symbol_error: false
    }
  }),
  methods: {
    makeBlobs: function () {
      this.saving = true
      const that = this
      if (that.currentNetwork.symbol_off
        || that.currentNetwork.symbol_on
        || that.currentNetwork.symbol_error) this.$swal({
        title: 'Subiendo imagen(es)...',
        text: 'Espera, por favor...',
        onOpen: () => that.$swal.showLoading(),
      })
      if (that.currentNetwork.symbol_off && that.currentNetwork.symbol_off.raw){
        const upload = new ActiveStorage.DirectUpload(that.currentNetwork.symbol_off.raw, '/rails/active_storage/direct_uploads')
        upload.create((error, blob) => {
          if (error) console.log(error)
          else {
            that.blobs.symbol_off = blob
            that.ready.symbol_off = true
            if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
          }
        })
      } else that.ready.symbol_off = true
      if (that.currentNetwork.symbol_on && that.currentNetwork.symbol_on.raw){
        const upload = new ActiveStorage.DirectUpload(that.currentNetwork.symbol_on.raw, '/rails/active_storage/direct_uploads')
        upload.create((error, blob) => {
          if (error) console.log(error)
          else {
            that.blobs.symbol_on = blob
            that.ready.symbol_on = true
            if (Object.keys(that.ready).every(key => that.ready[key])) that.handleSave()
          }
        })
      } else that.ready.symbol_on = true
      if (that.currentNetwork.symbol_error && that.currentNetwork.symbol_error.raw){
        const upload = new ActiveStorage.DirectUpload(that.currentNetwork.symbol_error.raw, '/rails/active_storage/direct_uploads')
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
    handleSave: function () {
      const that = this
      if (this.network) {
        this.$axios.put(`/networks/${this.network.id}`, {
          name: that.currentNetwork.name,
          description: that.currentNetwork.description,
          blobs: that.blobs
        })
          .then(({data}) => {
            that.saving = false
            that.$swal.close()
            that.$emit('close')
            that.$emit('fetch')
            that.ready = {
              symbol_off:   false,
              symbol_on:    false,
              symbol_error: false
            }
          }).catch(err => {
            console.log(err)
          })
      } else {
        that.$axios.post('/networks', {
          name: that.currentNetwork.name,
          description: that.currentNetwork.description,
          blobs: that.blobs
        })
          .then(result => {
            that.currentNetwork = {
              name: '',
              description: '',
              symbol_off:   null,
              symbol_on:    null,
              symbol_error: null
            }
            that.ready = {
              symbol_off:   false,
              symbol_on:    false,
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
    }
  },
  computed: {
    invalid () {
      this.errors.name = null
      this.errors.description = null

      if (this.currentNetwork.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
      if (this.currentNetwork.description.length < 30) this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${this.currentNetwork.description.length}.`

      return this.errors.name || this.errors.description
    }
  },
  watch: {
    network: function () {
      this.currentNetwork = {
          name: '',
          description: '',
          symbol_off:   null,
          symbol_on:    null,
          symbol_error: null
        }
      if (this.network) {
        this.currentNetwork = {
          ...this.currentNetwork,
          ...this.network
        }
      }
    }
  }
}
</script>
