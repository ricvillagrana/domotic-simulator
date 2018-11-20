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

        <label for="description" class="label">Símbolo:</label>
        <div class="flex flex-row justify-center">
          <img v-if="currentNetwork.image" class="image-preview" :src="currentNetwork.image.url" :alt="currentNetwork.image.name">
        </div>
        <drag-drop
        @images="currentNetwork.image = $event[0]"></drag-drop>

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
      image: null
    },
    errors: {
      name: null,
      description: null
    },
    saving: false
  }),
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (that.currentNetwork.image) {
        if (that.currentNetwork.image) this.$swal({
          title: 'Subiendo imagen...',
          text: 'Espera, por favor...',
          onOpen: () => that.$swal.showLoading(),
        })
        const upload = new ActiveStorage.DirectUpload(that.currentNetwork.image.raw, '/rails/active_storage/direct_uploads')
        upload.create((error, blob) => {
          if (error) console.log(error)
          else {
            if (this.network) {
              this.$axios.put(`/networks/${this.network.id}`, {
                name: that.currentNetwork.name,
                description: that.currentNetwork.description,
                blob: blob
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
              that.$axios.post('/networks', {
                name: that.currentNetwork.name,
                description: that.currentNetwork.description,
                blob: blob
              })
                .then(result => {
                  that.currentNetwork = {
                    name: '',
                    description: '',
                    image: null
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
        })
      } else {
        if (this.network) {
          this.$axios.put(`/networks/${this.network.id}`, {
            name: that.currentNetwork.name,
            description: that.currentNetwork.description
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
          that.$axios.post('/networks', {
            name: that.currentNetwork.name,
            description: that.currentNetwork.description
          })
            .then(result => {
              that.currentNetwork = {
                name: '',
                description: '',
                image: null
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
    uploadImage: function (image) {
      const that = this
      this.$swal({
        title: 'Subiendo imagen...',
        text: 'Espera, por favor...',
        onOpen: () => that.$swal.showLoading(),
      })
      const upload = new ActiveStorage.DirectUpload(image, '/rails/active_storage/direct_uploads')
      upload.create((error, blob) => {
        if (error) console.log(error)
        else {
          return blob

          // if (that.images.indexOf(image) === that.images.length -1) {
          //   const publication = {
          //     'images': that.images
          //   }
          //   that.$axios.put(that.url, { publication })
          //     .then(result => {
          //       that.$emit('uploaded')
          //       that.images = []
          //       console.log(document.getElementById('items').value = '')
          //       that.$swal.close()
          //     })
          //     .catch(err => {
          //       that.$swal({
          //         type: 'error',
          //         title: 'Error',
          //         text: err
          //       })
          //       that.images = []
          //       console.log(document.getElementById('items').value = '')
          //     })
          // }
        }
      })
    },
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
      if (this.network) {
        this.currentNetwork = {
          name: this.network.name,
          description: this.network.description,
          image: null
        }
      } else {
        this.currentNetwork = {
          name: '',
          description: '',
          image: null
        }
      }
    }
  }
}
</script>
