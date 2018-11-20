<template>
  <div class="flex flex-row min-h-screen">
    <div class="flex flex-col w-64 bg-black text-white px-0 py-2 fixed min-h-screen">
      <p class="text-3xl p-4 font-bold">IA Domótica</p>
      <div class="flex flex-col" v-for="(item, key) in menu" :key="`menu-${key}`">
        <a @click="$redirect(item.path)" class="bg-transparent hover:bg-blue-darker text-blue-lighter px-4 py-2 duration-1 cursor-pointer">
          {{ item.name }}
        </a>
        <div class="flex flex-col">
          <a v-for="(subitem, key) in item.submenu" :key="`menu-${key}`" @click="$redirect(subitem.path)" class="bg-transparent hover:bg-blue-darker text-blue-light pl-8 py-2 duration-1 cursor-pointer">
            {{ subitem.name }}
          </a>
        </div>
      </div>
      <div class="flex-1 flex justify-center">
        <p class="flex self-end px-6 text-grey">Made with <i class="fa fa-heart text-red-light"></i> by IA students.</p>
      </div>
    </div>
    <div class="flex flex-col flex-1 bg-grey-lighter p-8 ml-64">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'layout',
  data: () => ({
    menu: [{
        name: 'Inicio',
        path: '/'
      },
      {
        name: 'Dispositivos',
        path: '/devices',
        submenu: [{
            name: 'Sensores',
            path: '/sensors'
          },
          {
            name: 'Actuadores',
            path: '/actuators'
          },
          {
            name: 'Interfaces de Red',
            path: '/interfaces'
          },
          {
            name: 'Redes',
            path: '/networks'
          },
          {
            name: 'Unidades de medidición',
            path: '/unit_types'
          }
        ]
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
