<template>
  <div v-if="clock">
    <div class="flex flex-col justify-center">
      <div class="flex w-full justify-center text-center mb-0 p-2 bg-white text-blue-dark rounded-t border-b">
        <p class="font-bold">
          <span>{{ clock.day }} de {{ clock.monthText }} de {{ clock.year }}</span>
        </p>
      </div>
      <div class="flex w-full justify-center text-center mb-0 p-2 bg-white text-blue-dark">
        <p class="font-bold">
          <span>{{ clock.hours }}</span>
          <span> : </span>
          <span>{{ twoDigits(clock.minutes) }}</span>
          <span> : </span>
          <span>{{ twoDigits(clock.seconds) }}</span>
          <span> {{ clock.getFormat() }}</span>
        </p>
      </div>
      <div class="flex w-full justify-center rounded-t-none text-sm m-0 cursor-pointer">
        <span @click="toggleFormat" class="h-full w-2/3 button primary rounded-t-none rounded-br-none m-0 text-center border-r border-blue-light">{{ this.format !== 1 ? '12 hrs' : 'AM / PM' }}</span>
        <span @click="clock.toggleStatus()" class="h-full w-1/3 button rounded-t-none rounded-bl-none m-0 text-center" :class="!clock.isCounting() ? 'warning' : 'primary'">
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
      seconds: Number,
      onChange: Function
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
      },
      twoDigits: n => n > 9 ? n : `0${n}`
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
      },
    },
    created() {},
    updated() {
      this.$setSettings('time', this.$moment(this.clock.getTime())._d)
    },
    mounted() {
      const that = this
      this.$getSettings('time', (data) => {
        const serverTime = new Date(data)
        that.clock = this.$clock.setTime(
          serverTime,
          that.format, // format
          that.speed ? that.speed : 1 // speed
        )
        that.$emit('clock', this.clock)
      })
    }
  }
</script>
