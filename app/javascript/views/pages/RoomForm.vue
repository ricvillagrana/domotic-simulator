<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ room ? currentRoom.name : 'Nueva habitación' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre de la habitación:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre de la habitación. Ej. Planta brmoaja" v-model="currentRoom.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="sizes" class="label">Medidas:</label>
        <div class="flex flex-row flex-1 justify-around">
          <div class="flex flex-col w-1/2 mx-4">
            <label for="sizes.width" class="label">Ancho:</label>
            <div class="flex flex-row">
              <input type="number" min="100" name="sizes.width" class="input rounded-r-none" placeholder="Ancho" v-model="currentRoom.sizes.width" />
              <span class="bg-grey-darker text-white rounded-r p-2">px</span>
            </div>
          </div>
          <div class="flex flex-col w-1/2 mx-4">
            <label for="sizes.height" class="label">Alto:</label>
            <div class="flex flex-row">
              <input type="number" min="100" name="sizes.height" class="input rounded-r-none" placeholder="Ancho" v-model="currentRoom.sizes.height" />
              <span class="bg-grey-darker text-white rounded-r p-2">px</span>
            </div>
          </div>
        </div>

        <label for="position" class="label">Posición:</label>
        <div class="flex flex-row flex-1 justify-around">
          <div class="flex flex-col w-1/2 mx-4">
            <label for="position.x" class="label">X:</label>
            <div class="flex flex-row">
              <input type="number" min="0" name="position.x" class="input rounded-r-none" placeholder="Ancho" v-model="currentRoom.position.x" />
              <span class="bg-grey-darker text-white rounded-r p-2">px</span>
            </div>
          </div>
          <div class="flex flex-col w-1/2 mx-4">
            <label for="position.y" class="label">Y:</label>
            <div class="flex flex-row">
              <input type="number" min="0" name="position.y" class="input rounded-r-none" placeholder="Ancho" v-model="currentRoom.position.y" />
              <span class="bg-grey-darker text-white rounded-r p-2">px</span>
            </div>
          </div>
        </div>

        <label for="color" class="label">Colores:</label>
        <div class="flex flex-row flex-1 justify-around">
          <div class="flex flex-col w-1/2 mx-4">
            <label for="color.background" class="label">Fondo:</label>
            <div class="flex flex-row">
              <input type="color" min="0" name="color.background" class="rounded h-12 w-5/6" placeholder="Ancho" v-model="currentRoom.color.background" />
            </div>
          </div>
          <div class="flex flex-col w-1/2 mx-4">
            <label for="color.font" class="label">Letra:</label>
            <div class="flex flex-row">
              <input type="color" min="0" name="color.font" class="rounded h-12 w-5/6" placeholder="Ancho" v-model="currentRoom.color.font" />
            </div>
          </div>
        </div>


        <label for="description" class="label">Imagen de fondo:</label>
        <div class="flex flex-row justify-center mb-2">
          <img v-if="currentRoom.background" class="image-preview" :src="currentRoom.background.url" :alt="currentRoom.background.name">
        </div>
        <drag-drop
          @images="currentRoom.background = $event[0]"></drag-drop>

      </div>
    </div>
    <div slot="footer" class="float-right">
      <button class="button danger" @click="$emit('close')">Cancelar</button>
      <button @click="makeBlob" class="button success" :class="{ 'disabled' : invalid }" :disabled="invalid || saving"><i v-show="saving" class="fa fa-spinner spin"></i>Guardar</button>
    </div>
  </app-modal>
</template>

<script>
import AppModal from '../../components/AppModal'
import DragDrop from '../../components/DragDrop'

export default {
  name: 'room-form',
  props: ['open', 'room', 'floor'],
  components: {
    AppModal, DragDrop
  },
  data: () => ({
    currentRoom: {
      name: '',
      sizes: {
        width: 100,
        height: 100
      },
      position: {
        x: 0,
        y: 0
      },
      color: {
        background: '#000000',
        font: '#ffffff'
      },
      background: null
    },
    errors: {
      name: null
    },
    saving: false,
  }),
  methods: {
    makeBlob: function () {
      this.saving = true
      const that = this
      if (that.currentRoom.background) this.$swal({
        title: 'Subiendo imagen(es)...',
        text: 'Espera, por favor...',
        onOpen: () => that.$swal.showLoading(),
      })
      if (that.currentRoom.background && that.currentRoom.background.raw) {
        const upload = new ActiveStorage.DirectUpload(that.currentRoom.background.raw, '/rails/active_storage/direct_uploads')
        upload.create((error, blob) => {
          if (error) console.log(error)
          else {
            that.handleSave(blob)
          }
        })
      } else that.handleSave()
    },
    handleSave: function (blob = null) {
      const that = this
      let room = null
      if (blob) {
        room = {
          ...that.currentRoom,
          color: JSON.stringify(that.currentRoom.color),
          sizes: JSON.stringify(that.currentRoom.sizes),
          position: JSON.stringify(that.currentRoom.position),
          floor_id: that.floor.id,
          background: blob
        }
      } else {
        room = {
          ...that.currentRoom,
          color: JSON.stringify(that.currentRoom.color),
          sizes: JSON.stringify(that.currentRoom.sizes),
          position: JSON.stringify(that.currentRoom.position),
          floor_id: that.floor.id
        }
      }
      if (this.room) {
        this.$axios.put(`/rooms/${this.room.id}`, room)
          .then(({data}) => {
            that.saving = false
            that.$swal.close()
            that.$emit('close')
            that.$emit('fetch')
          }).catch(err => {
            console.log(err)
          })
      } else {
        that.$axios.post('/rooms', room)
          .then(result => {
            that.currentRoom = {
              name: '',
              sizes: {
                width: 100,
                height: 100
              },
              position: {
                x: 0,
                y: 0
              },
              color: {
                background: '#000000',
                font: '#ffffff'
              },
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
  },
  computed: {
    invalid () {
      this.errors.name = null

      if (this.currentRoom.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'

      return this.errors.name
    }
  },
  watch: {
    room: function () {
      this.currentRoom = {
        name: '',
        sizes: {
          width: 100,
          height: 100
        },
        position: {
          x: 0,
          y: 0
        },
        color: {
          background: '#000000',
          font: '#ffffff'
        },
        background: null
      }
      if (this.room) {
        this.currentRoom = {
          ...this.currentRoom,
          ...this.room
        }
      }
    }
  }
}
</script>
