<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ type ? currentType.name : 'Nueva tipo de dispositivo' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre del tipo:</label>
        <input type="text"
               name="name"
               class="input"
               :class="{ 'error' : errors.name }"
               placeholder="Nombre del dispositivo. Ej. Aire acondicionado"
               v-model="currentType.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description"
                  class="textarea"
                  :class="{ 'error' : errors.description }"
                  placeholder="Descripción"
                  v-model="currentType.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

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
  import AppModal from '../../../components/AppModal'
  export default {
    name: 'type-form',
    props: ['open', 'type'],
    components: {
      AppModal
    },
    data: () => ({
      currentType: {
        name: '',
        description: ''
      },
      errors: {
        name: null,
        description: null
      },
      saving: false
    }),
    methods: {
      handleSave() {
        this.saving = true
        const that = this
        this.$swal({
          title: 'Guardando',
          text: 'Espera, por favor...',
          onOpen: () => that.$swal.showLoading()
        })
        const type = {
          name: that.currentType.name,
          description: that.currentType.description
        }
        if (this.type) {
          this.$axios
            .put(`/device_types/${this.type.id}`, type)
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
            .post('/device_types', type)
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
      },
      saved(result) {
        const that = this
        if (result.data.status === 200) {
          that.currentType = {
            name: '',
            description: ''
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
      }
    },
    computed: {
      invalid() {
        this.errors.name = null
        this.errors.description = null

        if (this.currentType.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
        if (this.currentType.description.length < 30)
          this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${
            this.currentType.description.length
          }.`

        return this.errors.name || this.errors.description
      }
    },
    watch: {
      type() {
        this.currentType = {
          name: '',
          description: ''
        }
        if (this.type) {
          this.currentType = {
            ...this.currentType,
            ...this.type
          }
        }
      }
    }
  }
</script>
