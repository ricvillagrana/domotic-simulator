<template>
  <div class="bg-white mx-2 shadow hover:shadow-md rounded w-full md:w-1/4 z-10">
    <div class="py-6 text-center title font-semibold uppercase">
      <slot name="header"></slot>
    </div>
    <hr class="py-0 my-0 border border-grey-lighter">
    <div class="py-10 px-4">
      <slot name="content"></slot>
    </div>
    <div class="flex flex-row h-auto">
      <div class="py-4 flex flex-1 bg-grey-lighter cursor-pointer hover:bg-grey-light text-indigo-darker rounded rounded-t-none text-center uppercase font-bold flex items-center justify-center">
        <span>Create</span>
      </div>
      <div class="py-4 flex flex-1 bg-grey-lighter cursor-pointer hover:bg-grey-light text-indigo-darker rounded rounded-t-none text-center uppercase font-bold flex items-center justify-center">
        <span>Create</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'app-card'
}
</script>
