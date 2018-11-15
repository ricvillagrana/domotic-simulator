<template>
  <div class="flex flex-row h-full">
    <div class="flex flex-col w-64 bg-black text-white px-0 py-2">
      <p class="text-3xl p-4 font-bold">Domótica</p>
      <ul class="list-reset">
        <li 
          v-for="(item, key) in menu" 
          :key="`menu-${key}`" 
          @click="$redirect(item.path)"
          class="bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
          {{ item.name }}
        </li>
      </ul>
    </div>
    <div class="flex flex-col flex-1 bg-grey-lighter">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'layout',
  data: () => ({
    menu: [
      {
        name: 'Inicio',
        path: '/'
      },
      {
        name: 'Componentes',
        path: '/components'
      },
      {
        name: 'Pisos',
        path: '/floors'
      },
      {
        name: 'Simulación',
        path: '/simulation'
      },
    ]
  })
}
</script>
