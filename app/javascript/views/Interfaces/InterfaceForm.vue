<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ interface ? currentInterface.name : 'Nueva Interfaz de Red' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre de la interfaz:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre de la red" v-model="currentInterface.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description" class="textarea" :class="{ 'error' : errors.description }" placeholder="Descripción" v-model="currentInterface.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

        <label for="description" class="label">Descripción:</label>
        <select name="network_id" class="input bg-white" v-model="currentInterface.network_id">
          <option v-for="(network, key) in networks" :key="`network-${key}`" :value="network.id">{{ network.name }}</option>
        </select>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

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

export default {
  name: 'interface-form',
  props: ['open', 'interface'],
  components: {
    AppModal
  },
  data: () => ({
    currentInterface: {
      name: '',
      description: '',
      network_id: null
    },
    errors: {
      name: null,
      description: null
    },
    saving: false,
    networks: []
  }),
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (this.interface) {
        this.$axios.put(`/interfaces/${this.interface.id}`, {
          ...that.currentInterface
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
        that.$axios.post('/interfaces', {
          ...that.currentInterface
        })
          .then(result => {
            that.currentInterface = {
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
    },
    fetchNetworks: function () {
      const that = this
      this.$axios.get('/networks.json')
        .then(({
          data
        }) => {
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
    invalid () {
      this.errors.name = null
      this.errors.description = null

      if (this.currentInterface.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
      if (this.currentInterface.description.length < 30) this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${this.currentInterface.description.length}.`

      return this.errors.name || this.errors.description
    }
  },
  watch: {
    interface: function () {
      this.fetchNetworks()
      if (this.interface) {
        this.currentInterface = {
          name: this.interface.name,
          description: this.interface.description,
          network_id: this.interface.network_id
        }
      } else {
        this.currentInterface = {
          name: '',
          description: '',
          network_id: null
        }
      }
    }
  }
}
</script>
