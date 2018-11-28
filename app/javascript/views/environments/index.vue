<template>
  <div>
    <p class="title text-3xl mb-2">
      Variables ambientales
      <button @click="addOptions.open = true" class="button primary text-sm">
        Agregar
      </button>
    </p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="envs.length === 0" class="self-center text-2xl text-grey-dark">
          No hay Unidades de medición aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega una</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th class="border-b-2 border border-grey-light py-2 px-8" v-for="(header, key) in ['Nombre', 'Unidad de medición', 'Predeterminado', 'Rango', 'Tendencia', 'Tiempo para estabilizar', 'Acciones']" :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in envs" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.unit_type.unit }} [{{ row.unit_type.symbol }}]</td>
              <td class="border border-grey-light py-2 px-4 text-center"><strong>{{ row.default }} {{ row.unit_type.symbol }}</strong></td>
              <td class="border border-grey-light py-2 px-4 text-center">De <strong>{{ row.minimum }} {{ row.unit_type.symbol }}</strong> a <strong>{{ row.maximum }} {{ row.unit_type.symbol }}</strong></td>
              <td class="border border-grey-light py-2 px-4 text-center"><strong>{{ row.tendence }} {{ row.unit_type.symbol }}</strong></td>
              <td class="border border-grey-light py-2 px-4 text-center"><strong>{{ row.time_to_tendence }} seg.</strong></td>
              <td class="border border-grey-light py-2 px-4">
                <div class="flex flex-row">
                  <button @click="openEdit(row)" class="button warning">Editar</button>
                  <button @click="handleDelete(row)" class="button danger">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <environment-form
      :open="addOptions.open"
      @fetch="fetchEnvironments"
      @close="addOptions.open = false"></environment-form>

    <environment-form
      :open="editOptions.open"
      :environment="editOptions.env"
      @fetch="fetchEnvironments"
      @close="editOptions.open = false"></environment-form>
  </div>
</template>

<script>
import EnvironmentForm from './EnvironmentForm'

export default {
  name: 'environments',
  data: () => ({
    envs: [],
    addOptions: {
      open: false
    },
    editOptions: {
      open: false,
      env: null
    }
  }),
  components: {
    EnvironmentForm
  },
  beforeMount() {
    this.fetchEnvironments()
  },
  methods: {
    openEdit: function (env) {
      this.editOptions.open = true
      this.editOptions.env = env
    },
    handleDelete: function (env) {
      const that = this
      this.$swal({
        title: `Se eliminará la variable de ambiente ${env.name}`,
        text: "No se podrá recuprar",
        type: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Eliminar',
        cancelButtonText: 'No, cancelar',
        cancelButtonColor: 'red',
        reverseButtons: true
      }).then((result) => {
        if (result.value) {
          this.$swal({
            title: 'Eliminando...',
            onOpen: () => that.$swal.showLoading()
          })
          this.$axios.delete(`/environments/${env.id}`)
            .then(({
              data
            }) => {
              if (data.status == 200) {
                that.$swal({
                  type: 'success',
                  title: 'Elminada',
                  text: `La unidad de medicón ${env.name} se eliminó de manera correcta.`,
                })
              }
              that.fetchEnvironments()
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: 'No se pudo eliminar la variable de ambiente.',
                footer: `Error: ${err}`
              })
            })
        }
      })
    },
    fetchEnvironments: function () {
      const that = this
      this.$axios.get('/environments.json')
        .then(({
          data
        }) => {
          that.envs = data.environments
        })
        .catch(err => {
          that.$swal({
            type: 'error',
            title: 'Error',
            text: err
          })
        })
    }
  }
}
</script>
