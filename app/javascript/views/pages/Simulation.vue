<template>
  <div class="simulation flex flex-row min-h-screen">
    <div class="flex flex-col w-48 bg-black border-l border-grey-darkest text-white px-0 py-2 fixed min-h-screen">
      <p class="text-xl p-4 font-bold">Pisos de la casa</p>
      <div class="flex flex-col">
        <a class="bg-transparent font-bold text-white px-4 py-2 duration-1 cursor-pointer">
          PISOS
        </a>
        <div class="flex flex-col" v-for="(item, key) in floors" :key="`floors-${key}`">
          <a @click="selectFloor(item)"
             :class="{ 'font-bold text-white' : selected === item }"
             class="pl-6 bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
            {{ selected === item ? '➜ ' : '' }}{{ item.name }}
          </a>
        </div>
        <a class="bg-transparent font-bold text-white px-4 py-2 duration-1 cursor-pointer">
          ACCIONES
        </a>
        <div class="flex flex-col">
          <a @click="addOptions.open = true" class="pl-6 bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
            <i class="fa fa-plus"></i>Nueva habitación
          </a>
        </div>
      </div>
    </div>
    <div v-if="selected && selected.background" class="bg-grey-lighter ml-48 flex flex-1 max-h-screen overflow-hidden">
      <!-- Background -->
      <img class="" id="image" :src="selected.background.url" :alt="selected.background.filename">

      <div class="flex flex-row absolute w-2/3 h-full">
        <div class="flex flex-col flex-1 w-full h-full">
          <vue-draggable v-for="(room, key) in selected.rooms"
                         :key="`room-${key}`"
                         :minh="0"
                         :minw="0"
                         :x="parseInt(room.position.x)"
                         :y="parseInt(room.position.y)"
                         :w="parseInt(room.sizes.width)"
                         :h="parseInt(room.sizes.height)"
                         :parent="true"
                         @activated="activeRoom = room"
                         @deactivated="activeRoom === room ? activeRoom = null : null"
                         @resizestop="onResize"
                         @dragstop="onDrag"
                         :style="`background: ${room.color.background}; color: ${room.color.font};`"
                         class="cursor-move flex justify-center items-center opacity-75">
            <div class="flex flex-col justify-center text-center">
              <p>{{ room.name }}</p>
              <div :class="activeRoom === room ? 'opacity-100' : 'opacity-0'" class="flex flex-row flex-wrap duration-1 justify-center">
                <button @click="onEdit(room)" :style="activeRoom === room ? 'transform: rotateX(0deg); height: auto;' : 'transform: rotateX(90deg); height: 0;'" class="delay-1 duration-5 button warning p-0" type="button" name="button ">Editar</button>
                <button @click="onDelete(room)" :style="activeRoom === room ? 'transform: rotateX(0deg); height: auto;' : 'transform: rotateX(90deg); height: 0;'" class="delay-1 duration-5 button danger p-0" type="button" name="button ">Eliminar</button>
              </div>
            </div>
          </vue-draggable>
        </div>
      </div>
    </div>

    <room-form :open="addOptions.open"
               :floor="selected"
               @fetch="fetchRooms"
               @close="addOptions.open = false"></room-form>

    <room-form :open="editOptions.open"
               :floor="selected"
               :room="editOptions.room"
               @fetch="fetchRooms"
               @close="editOptions.open = false"></room-form>
  </div>
</template>

<script>
  import RoomForm from './RoomForm'

  export default {
    name: 'simulation',
    data: () => ({
      floors: [],
      selected: null,
      activeRoom: null,
      addOptions: {
        open: false
      },
      editOptions: {
        open: false,
        room: null
      }
    }),
    components: {
      RoomForm
    },
    beforeMount() {
      this.fetchFloors()
    },
    methods: {
      selectFloor (floor) {
        this.selected = null
        setTimeout(() => this.selected = floor, 50)
      },
      onEdit (room) {
        this.editOptions.room = room
        this.editOptions.open = true
      },
      onDelete (room) {
        const that = this
        this.$swal({
          title: `Se eliminará la habitación ${room.name}`,
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
            this.$axios.delete(`/rooms/${room.id}`)
              .then(({
                data
              }) => {
                if (data.status == 200) {
                  that.$swal({
                    type: 'success',
                    title: 'Elminada',
                    text: `La habitación ${room.name} se eliminó de manera correcta.`,
                  })
                }
                that.fetchRooms()
              })
              .catch(err => {
                that.$swal({
                  type: 'error',
                  title: 'Error',
                  text: 'No se pudo eliminar la habitación.',
                  footer: `Error: ${err}`
                })
              })
          }
        })
      },
      onResize (x, y, width, height) {
        const that = this
        setTimeout(() => {
          this.$axios
            .put(`/rooms/${this.activeRoom.id}`, {
              sizes: JSON.stringify({ width, height }),
              position: JSON.stringify({ x, y })
            })
            .then(({ data }) => {
              that.activeRoom.sizes = { width, height }
              that.activeRoom.position = { x, y }
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: err
              })
            })
        }, 10)
      },
      onDrag (x, y) {
        const that = this
        setTimeout(() => {
          this.$axios
            .put(`/rooms/${this.activeRoom.id}`, {
              position: JSON.stringify({ x, y })
            })
            .then(({ data }) => {
              that.activeRoom.position = { x, y }
            })
            .catch(err => {
              that.$swal({
                type: 'error',
                title: 'Error',
                text: err
              })
            })
        }, 10)
      },
      fetchFloors() {
        const that = this
        this.$axios.get('/floors.json').then(({ data }) => {
          that.floors = data.floors
          if (that.floors.length > 0 && !that.selected) that.selected = that.floors[0]
        })
      },
      fetchRooms() {
        const that = this
        this.$axios.get(`/rooms/${this.selected.id}.json`).then(({ data }) => {
          that.floors.filter(floor => floor.id === that.selected.id)[0].rooms = []
          that.selected.rooms = []
          setTimeout(() => {
            that.floors.filter(floor => floor.id === that.selected.id)[0].rooms = data.rooms
            that.selected.rooms = data.rooms
          }, 10)
        })
      }
    },
    watch: {
      selected () {
        this.fetchRooms()
      }
    }
  }
</script>
