<template>
  <div class="simulation flex flex-row min-h-screen">
    <div class="flex flex-col w-48 bg-black border-l border-grey-darkest text-white px-0 py-2 fixed min-h-screen">
      <p class="text-xl p-4 font-bold">Pisos de la casa</p>
      <div class="flex flex-col">
        <a class="bg-transparent font-bold text-white px-4 py-2 duration-1 cursor-pointer">
                  PISOS
                </a>
        <div class="flex flex-col" v-for="(item, key) in floors" :key="`floors-${key}`">
          <a @click="selected = item"
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
    <div v-if="selected" class="bg-grey-lighter ml-48 flex flex-1 max-h-screen overflow-hidden">
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
                         class="cursor-move flex justify-center items-center opacity-50">
            <p>{{ room.name }}</p>
          </vue-draggable>
        </div>
      </div>
    </div>

    <room-form :open="addOptions.open"
               :floor="selected"
               @fetch="fetchFloors"
               @close="addOptions.open = false"></room-form>

    <room-form :open="editOptions.open"
               :floor="selected"
               :room="editOptions.room"
               @fetch="fetchFloors"
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
      onResize (x, y, width, height) {
        const that = this
        setTimeout(() => {
          this.$axios.put(`/rooms/${this.activeRoom.id}`, {
            sizes: JSON.stringify({width, height}),
            position: JSON.stringify({x, y}),
          }).then(({data}) => console.log(data))
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
          this.$axios.put(`/rooms/${this.activeRoom.id}`, {
            position: JSON.stringify({x, y}),
          }).then(({data}) => console.log(data))
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
          if (that.floors.length > 0) that.selected = that.floors[0]
        })
      }
    }
  }
</script>
