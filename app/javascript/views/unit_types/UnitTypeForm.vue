<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ unit ? currentUnit.name : 'Nueva Interfaz de Red' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="unit" class="label">Unidad:</label>
        <input type="text" name="unit" class="input" :class="{ 'error' : errors.unit }" placeholder="Ej. Celsius, Kilogramo" v-model="currentUnit.unit" />
        <span class="input-error-message" v-show="errors.unit">{{ errors.unit }}</span>

        <label for="symbol" class="label">Símbolo:</label>
        <input type="text" name="symbol" class="input" :class="{ 'error' : errors.symbol }" placeholder="Ej. °C, kg" v-model="currentUnit.symbol" />
        <span class="input-error-message" v-show="errors.symbol">{{ errors.symbol }}</span>

        <label for="description" class="label">Descripción:</label>
        <textarea name="description" class="textarea" :class="{ 'error' : errors.description }" placeholder="Descripción" v-model="currentUnit.description"></textarea>
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
  name: 'unit-type-form',
  props: ['open', 'unit'],
  components: {
    AppModal
  },
  data: () => ({
    currentUnit: {
      description: '',
      unit: '',
      symbol: ''
    },
    errors: {
      description: null,
      unit: null,
      symbol: null
    },
    saving: false,
    units: []
  }),
  beforeMount () {
    this.fetchUnits()
  },
  methods: {
    handleSave: function () {
      this.saving = true
      const that = this
      if (this.unit) {
        this.$axios.put(`/unit_types/${this.unit.id}`, {
          ...that.currentUnit
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
        that.$axios.post('/unit_types', {
          ...that.currentUnit
        })
          .then(result => {
            that.currentUnit = {
              description: '',
              unit: '',
              symbol: ''
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
    fetchUnits: function () {
      const that = this
      this.$axios.get('/unit_types.json')
        .then(({
          data
        }) => {
          that.units = data.unit_types
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
      this.errors.description = null
      this.errors.unit = null
      this.errors.symbol = null

      if (this.currentUnit.unit === '') this.errors.unit = 'Nombre de la unidad inválido, debe contener algo.'
      if (this.currentUnit.symbol === '') this.errors.symbol = 'Símbolo de la unidad inválido, debe contener algo.'
      if (this.currentUnit === null || this.currentUnit.description.length < 30) this.errors.description = `Descripción inválida, debe contener al menos 30 caracteres, tú tienes ${this.currentUnit.description.length}.`


      return this.errors.description || this.errors.unit || this.errors.symbols
    }
  },
  watch: {
    unit: function () {
      this.fetchUnits()
      if (this.unit) {
        this.currentUnit = { ...this.unit }
      } else {
        this.currentUnit = {
          description: '',
          unit: '',
          symbol: ''
        }
      }
    }
  }
}
</script>
