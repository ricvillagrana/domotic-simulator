<template>
  <div>
    <p class="title text-3xl mb-2">Tipos de dispositivos <button @click="addOptions.open = true" class="button primary text-sm">Agregar</button></p>
    <div class="flex flex-row">
      <div class="flex flex-col flex-1">
        <div v-if="types.length === 0" class="self-center text-2xl text-grey-dark">
          No hay ninguno aún, <span @click="addOptions.open = true" class="text-blue cursor-pointer">agrega uno</span>.
        </div>
        <table class="table-fixed rounded bg-white" v-else>
          <thead>
            <tr>
              <th v-for="(header, key) in ['Nombre', 'Descripción', 'Acciones']"
                  class="border-b-2 border border-grey-light py-2 px-8"
                  :key="`header-${key}`">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr class="hover:bg-blue-lightest duration-1" v-for="(row, key) in types" :key="`data-${key}`">
              <td class="border border-grey-light py-2 px-4">{{ row.name }}</td>
              <td class="border border-grey-light py-2 px-4">{{ row.description }}</td>
              <td class="border border-grey-light py-2 px-4">
                <div class="flex flex-row">
                  <button @click="handleEdit(row)" class="button warning">Editar</button>
                  <button @click="handleDelete(row)" class="button danger">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <type-form :open="addOptions.open"
               @fetch="fetchTypes"
               @close="addOptions.open = false"></type-form>

    <type-form :open="editOptions.open"
               :type="editOptions.type"
               @fetch="fetchTypes"
               @close="editOptions.open = false"></type-form>
  </div>
</template>

<script>
  import TypeForm from './TypeForm'

  export default {
    name: 'device-types',
    components: { TypeForm },
    props: {},
    data() {
      return {
        types: [],
        addOptions: {
          open: false
        },
        editOptions: {
          open: false,
          type: null
        }
      }
    },
    computed: {},
    methods: {
      handleEdit(type) {
        this.editOptions.type = type
        this.editOptions.open = true
      },
      handleDelete(type) {
        const that = this
        this.$swal({
          title: `Se eliminará el tipo ${type.name}`,
          text: 'No se podrá recuprar',
          type: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Eliminar',
          cancelButtonText: 'No, cancelar',
          cancelButtonColor: 'red',
          reverseButtons: true
        }).then(result => {
          if (result.value) {
            this.$swal({
              title: 'Eliminando...',
              onOpen: () => that.$swal.showLoading()
            })
            this.$axios
              .delete(`/device_types/${type.id}`)
              .then(({ data }) => {
                if (data.status == 200) {
                  that.$swal({
                    type: 'success',
                    title: 'Elminado',
                    text: `El type ${type.name} se eliminó de manera correcta.`
                  })
                }
                that.fetchDevices()
              })
              .catch(err => {
                that.$swal({
                  type: 'error',
                  title: 'Error',
                  text: 'No se pudo eliminar el dispositivo.',
                  footer: `Error: ${err}`
                })
              })
          }
        })
      },
      fetchTypes() {
        const that = this
        this.$axios.get('/device_types.json').then(({ data }) => {
          that.types = data.device_types
        })
      }
    },
    created() {},
    mounted() {
      this.fetchTypes()
    }
  }
</script>

<style lang='scss' scoped>

</style>
