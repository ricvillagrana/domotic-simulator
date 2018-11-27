<template>
  <app-modal :open="open" @close="$emit('close')">
    <div slot="header">
      {{ environment ? currentEnvironment.name : 'Nueva variable ambiental' }}
    </div>
    <div slot="content">
      <div class="flex flex-col">
        <label for="name" class="label">Nombre:</label>
        <input type="text"
               name="name"
               class="input"
               :class="{ 'error' : errors.name }"
               placeholder="Ej. Temperatura, Presencia"
               v-model="currentEnvironment.name" />
        <span class="input-error-message" v-show="errors.name">{{ errors.name }}</span>

        <label for="unit_type_id" class="label">Unidad de medición:</label>
        <select name="unit_type_id" class="input bg-white" :class="{ 'error' : errors.unit_type_id }" v-model="currentEnvironment.unit_type_id">
          <option value="0" disabled selected> - Selecciona una - </option>
          <option v-for="(unit, key) in units" :key="`unit-${key}`" :value="unit.id">[{{ unit.symbol }}] {{ unit.unit }}</option>
        </select>
        <span class="input-error-message" v-show="errors.unit_type_id">{{ errors.unit_type_id }}</span>

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
  import AppModal from '../../components/AppModal'

  export default {
    name: 'environment-form',
    props: ['open', 'environment'],
    components: {
      AppModal
    },
    data: () => ({
      currentEnvironment: {
        name: '',
        unit_type_id: 0
      },
      errors: {
        name: null,
        unit_type_id: null
      },
      units: [],
      saving: false
    }),
    beforeMount() {
      this.fetchUnits()
    },
    methods: {
      handleSave() {
        this.saving = true
        const that = this
        if (this.environment) {
          this.$axios
            .put(`/environments/${this.environment.id}`, {
              ...that.currentEnvironment
            })
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
            .post('/environments', {
              ...that.currentEnvironment
            })
            .then(result => {
              that.currentEnvironment = {
                name: '',
                unit_type_id: 0
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
      fetchUnits() {
        const that = this
        this.$axios
          .get('/unit_types.json')
          .then(({ data }) => {
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
      invalid() {
        this.errors.name = null
        this.errors.unit_type_id = null

        if (this.currentEnvironment.name === '')
          this.errors.name = 'Nombre de la unidad inválido, debe contener algo.'
        if (this.currentEnvironment.unit_type_id <= 0 || this.currentEnvironment.unit_type_id === null)
          this.errors.unit_type_id = 'Unidad de medición inválida, selecciona una.'

        return this.errors.name || this.errors.unit_type_id
      }
    },
    watch: {
      environment() {
        this.fetchUnits()
        if (this.environment) {
          this.currentEnvironment = { ...this.environment }
        } else {
          this.currentEnvironment = {
            name: '',
            unit_type_id: 0
          }
        }
      }
    }
  }
</script>
