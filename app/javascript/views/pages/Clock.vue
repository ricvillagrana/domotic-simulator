<template>
  <div v-if="clock">
    <div class="flex flex-col justify-center">
      <div class="flex w-full justify-center text-center mb-0 p-2 bg-white text-blue-dark rounded-t">
        <p class="font-bold">
          <span>{{ clock.getHours() }}</span>
          <span> : </span>
          <span>{{ clock.getMinutes() }}</span>
          <span> : </span>
          <span>{{ clock.getSeconds() }}</span>
          <span> {{ clock.getFormat() }}</span>
        </p>
      </div>
      <div class="flex w-full justify-center rounded-t-none text-sm m-0 cursor-pointer">
        <span @click="toggleFormat" class="h-full w-2/3 button primary rounded-t-none rounded-br-none m-0 text-center border-r border-blue-light">{{ this.format !== 1 ? '12 hrs' : 'AM / PM' }}</span>
        <span @click="clock.toggleStatus()" class="h-full w-1/3 button rounded-t-none rounded-bl-none m-0 text-center" :class="!clock.isCounting() ? 'warning pulsar' : 'primary'">
          <i v-if="!clock.isCounting()" class="fa fa-play"></i>
          <i v-else class="fa fa-pause"></i>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'clock',
    components: {},
    props: {
      speed: Number,
      seconds: Number
    },
    data() {
      return {
        clock: null,
        format: 0
      }
    },
    computed: {},
    methods: {
      toggleFormat() {
        this.format = this.format === 1 ? 0 : 1
        this.clock.setFormat(this.format)
      }
    },
    watch: {
      speed() {
        if (this.speed <= 0) this.speed = 1
        this.clock.stop()
        this.clock.setSpeed(this.speed)
        this.clock.start()
      },
      seconds() {
        this.clock.setSecondsToCount(this.seconds)
      }
    },
    created() {},
    mounted() {
      this.clock = new this.$clock(
        0, // seconds
        0, // minutes
        0, // hours
        this.format, // format
        this.speed ? this.speed : 1 // speed
      )
      this.$emit('clock', this.clock)
    }
  }
</script>
