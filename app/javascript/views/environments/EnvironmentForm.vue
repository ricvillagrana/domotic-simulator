<template>
  <app-modal :open="open" @close="$emit('close')" :size="'1/3'">
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

        <label for="default" class="label">Predeterminado:</label>
        <input type="number"
               name="default"
               class="input"
               :class="{ 'error' : errors.default }"
               v-model="currentEnvironment.default" />
        <span class="input-error-message" v-show="errors.default">{{ errors.default }}</span>

        <div class="flex flex row">
          <div class="flex flex-col flex-1">
            <label for="minimum" class="label">Valor mínimo:</label>
            <input type="number"
                   name="minimum"
                   class="input"
                   :class="{ 'error' : errors.minimum }"
                   v-model="currentEnvironment.minimum" />
            <span class="input-error-message" v-show="errors.minimum">{{ errors.minimum }}</span>
          </div>
          <div class="flex flex-col flex-1">
            <label for="maximum" class="label">Valor máximo:</label>
            <input type="number"
                   name="maximum"
                   class="input"
                   :class="{ 'error' : errors.maximum }"
                   v-model="currentEnvironment.maximum" />
            <span class="input-error-message" v-show="errors.maximum">{{ errors.maximum }}</span>
          </div>
        </div>

        <div class="flex flex row">
          <div class="flex flex-col flex-1">
            <label for="tendence" class="label">Tendencia:</label>
            <input type="number"
                   name="tendence"
                   class="input"
                   :class="{ 'error' : errors.tendence }"
                   v-model="currentEnvironment.tendence" />
            <span class="input-error-message" v-show="errors.tendence">{{ errors.tendence }}</span>
          </div>
          <div class="flex flex-col flex-1">
            <label for="time_to_tendence" class="label">Segundos para estabilizar:</label>
            <input type="number"
                   name="time_to_tendence"
                   class="input"
                   :class="{ 'error' : errors.time_to_tendence }"
                   v-model="currentEnvironment.time_to_tendence" />
            <span class="input-error-message" v-show="errors.time_to_tendence">{{ errors.time_to_tendence }}</span>
          </div>
        </div>

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

  const environment = {
    name: '',
    unit_type_id: 0,
    default: 0,
    minimum: 0,
    maximum: 0,
    tendence: 0,
    time_to_tendence: 0
  }

  export default {
    name: 'environment-form',
    props: ['open', 'environment'],
    components: {
      AppModal
    },
    data: () => ({
      currentEnvironment: {
        ...environment
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
                ...environment
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
          this.currentEnvironment = { ...environment, ...this.environment }
        } else {
          this.currentEnvironment = {
            ...environment
          }
        }
      }
    }
  }
</script>
