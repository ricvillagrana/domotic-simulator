<template>
  <div class="fixed w-full h-full z-40 pin-t pin-l flex justify-center items-center" :class="{ 'is-active' : open}" v-show="open">
    <div class="fixed w-full h-full bg-black opacity-75 pin-t pin-l" @click="$emit('close')"></div>
    <div class="rounded overflow-hidden bg-white shadow-md border-1 border-solid border border-grey-lighter p-8 m-5 z-50"  :class="size ? `w-${size}` : 'w-1/2'">
      <header class="modal-card-head">
        <p class="title text-3xl"><slot name="header"></slot></p>
        <button class="delete" aria-label="close" @click="$emit('close')"></button>
      </header>
      <section class="mb-8">
        <slot name="content"></slot>
      </section>
      <footer>
        <slot name="footer"></slot>
      </footer>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'app-modal',
    props: ['open', 'size']
  }
</script>
