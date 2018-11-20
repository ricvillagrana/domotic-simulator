<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ inter ? currentInterface.name : 'Nueva Interfaz de Red' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre de la interfaz:</label>
        <input type="text" name="name" class="input" :class="{ 'error' : errors.name }" placeholder="Nombre de la red" v-model="currentInterface.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description" class="textarea" :class="{ 'error' : errors.description }" placeholder="Descripción" v-model="currentInterface.description"></textarea>
        <span class="input-error-message" v-show="errors.description">{{ errors.description }}</span>

        <label for="description" class="label">Red:</label>
        <select name="network_id" class="input bg-white" :class="{ 'error' : errors.network_id }" v-model="currentInterface.network_id">
              <option value="0" disabled selected> - Selecciona una red - </option>

          <option v-for="(network, key) in networks" :key="`network-${key}`" :value="network.id">{{ network.name }}</option>
        </select>
        <span class="input-error-message" v-show="errors.network_id">{{ errors.network_id }}</span>

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
  props: ['open', 'inter'],
  components: {
    AppModal
  },
  data: () => ({
    currentInterface: {
      name: '',
      description: '',
      network_id: 0
    },
    errors: {
      name: null,
      description: null
    },
    saving: false,
    networks: []
  }),
  beforeMount () {
    this.fetchNetworks()
  },
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (this.inter) {
        this.$axios.put(`/interfaces/${this.inter.id}`, {
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
              network_id: 0
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
      this.errors.network_id = null

      if (this.currentInterface.name === '') this.errors.name = 'Nombre inválido, debe contener algo.'
      if (this.currentInterface.network_id <= 0 || this.currentInterface.network_id === null) this.errors.network_id = 'Red inválida, selecciona una.'
      if (this.currentInterface.description.length < 30) this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${this.currentInterface.description.length}.`

      return this.errors.name || this.errors.description || this.errors.network_id
    }
  },
  watch: {
    inter: function () {
      this.fetchNetworks()
      if (this.inter) {
        this.currentInterface = {
          name: this.inter.name,
          description: this.inter.description,
          network_id: this.inter.network_id
        }
      } else {
        this.currentInterface = {
          name: '',
          description: '',
          network_id: 0
        }
      }
    }
  }
}
</script>
