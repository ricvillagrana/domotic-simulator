<template>
  <div class="simulation flex flex-row min-h-screen">
    <div class="flex flex-col w-48 bg-black border-l border-grey-darkest text-white px-0 py-2 fixed min-h-screen">
      <p class="text-xl p-4 font-bold">Pisos de la casa</p>
      <div class="flex flex-col">
        <a class="bg-transparent font-bold text-white px-4 py-2 duration-1 cursor-pointer">
          PISOS
        </a>
         <div class="flex flex-col" v-for="(item, key) in floors" :key="`floors-${key}`">
            <a @click="selected = item" :class="{ 'font-bold text-white' : selected === item }" class="pl-8 bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
            {{ selected === item ? '➜ ' : '' }}{{ item.name }}
          </a>
        </div>
        <a class="bg-transparent font-bold text-white px-4 py-2 duration-1 cursor-pointer">
          ACCIONES
        </a>
         <div class="flex flex-col">
          <a class="pl-8 bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
            Nueva habitación
          </a>
        </div>
      </div>
    </div>
    <div class="flex flex-col flex-1 bg-grey-lighter ml-48 overflow-scroll">
      <!-- Background -->
      <img v-if="selected" class="flex flex-1" :src="selected.background.url" :alt="selected.background.filename">
    </div>
  </div>
</template>

<script>
export default {
  name: 'simulation',
  data: () => ({
    floors: [],
    selected: null
  }),
  beforeMount () {
    this.fetchFloors()
  },
  methods: {
  fetchFloors () {
    const that = this
    this.$axios.get('/floors.json')
    .then(({data}) => {
      that.floors = data.floors
      if (that.floors.length > 0) that.selected = that.floors[0]
    })
  }
  }
}
</script>
