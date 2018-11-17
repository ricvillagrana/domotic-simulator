<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      Nueva Red
    </div>
    <div slot="content">
      <form class="flex flex-col">
        <label for="name" class="label">Nombre de la red:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre de la red" v-model="currentNetwork.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción</label>
        <textarea name="description" class="textarea" :class="{ 'error' : errors.description }" placeholder="Descripción" v-model="currentNetwork.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

      </form>
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
  name: 'network-form',
  props: ['open', 'network'],
  components: {
    AppModal
  },
  data: () => ({
    currentNetwork: {
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
    handleSave: function () {
      this.saving = true
      const that = this
      if (this.network) {
        this.$axios.put(`/networks/${this.network.id}`, that.currentNetwork)
          .then(({data}) => {
            that.$emit('fetch')
            that.$emit('close')
          }).catch(err => {
            console.log(err)
          })
      } else {
        that.$axios.post('/networks', that.currentNetwork)
          .then(result => {
            that.currentNetwork = {
              name: '',
              description: ''
            }
            that.$emit('fetch')
            that.$emit('close')
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
      if (this.network) {
        this.currentNetwork = {
          name: this.network.name,
          description: this.network.description
        }
      } else {
        this.currentNetwork = {
          name: '',
          description: ''
        }
      }
    }
  }
}
</script>
