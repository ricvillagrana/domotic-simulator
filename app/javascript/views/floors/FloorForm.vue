<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ floor ? currentFloor.name : 'Nueva piso' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre del piso:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre del piso. Ej. Planta baja" v-model="currentFloor.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>


        <label for="description" class="label">Imagen de fondo:</label>
        <div class="flex flex-row justify-center mb-2">
          <img v-if="currentFloor.background" class="image-preview" :src="currentFloor.background.url" :alt="currentFloor.background.name">
        </div>
        <drag-drop
          @images="currentFloor.background = $event[0]"></drag-drop>

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
  name: 'floor-form',
  props: ['open', 'floor'],
  components: {
    AppModal, DragDrop
  },
  data: () => ({
    currentFloor: {
      name: '',
      background: null,
    },
    errors: {
      name: null,
    },
    saving: false,
  }),
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (that.currentFloor.background) this.$swal({
        title: 'Subiendo imagen(es)...',
        text: 'Espera, por favor...',
        onOpen: () => that.$swal.showLoading(),
      })
      if (that.currentFloor.background && that.currentFloor.background.raw) {
        const upload = new ActiveStorage.DirectUpload(that.currentFloor.background.raw, '/rails/active_storage/direct_uploads')
        upload.create((error, blob) => {
          if (error) console.log(error)
          else {
            if (this.floor) {
              this.$axios.put(`/floors/${this.floor.id}`, {
                name: that.currentFloor.name,
                background: blob
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
              that.$axios.post('/floors', {
                name: that.currentFloor.name,
                background: blob
              })
                .then(result => {
                  that.currentFloor = {
                    name: '',
                    description: '',
                    background: null
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
        if (this.floor) {
          this.$axios.put(`/floors/${this.floor.id}`, {
            name: that.currentFloor.name,
            description: that.currentFloor.description,
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
          that.$axios.post('/floors', {
            name: that.currentFloor.name,
            description: that.currentFloor.description,
            background: null
          })
            .then(result => {
              that.currentFloor = {
                name: '',
                description: '',
                background: null
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
    }
  },
  computed: {
    invalid () {
      this.errors.name = null

      if (this.currentFloor.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'

      return this.errors.name
    }
  },
  watch: {
    floor: function () {
      this.currentFloor = {
          name: '',
          description: '',
          background:   null
        }
      if (this.floor) {
        this.currentFloor = {
          ...this.currentFloor,
          ...this.floor
        }
      }
    }
  }
}
</script>
