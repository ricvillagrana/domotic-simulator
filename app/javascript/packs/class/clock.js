class Clock {
  constructor(seconds = 0, minutes = 0, hours = 0, format = 0, speed = 1, stc = 1) {
    this.seconds = seconds
    this.minutes = minutes
    this.hours = hours
    this.days = 0
    this.format = format
    this.speed = speed
    this.secondsToCount = stc
    this.status = false

    this.clockCoutner = null
  }

  check() {
    if (this.seconds >= 60) {
      this.seconds = this.seconds - 60
      this.minutes = this.minutes + 1
    }
    if (this.minutes >= 60) {
      this.minutes = this.minutes - 60
      this.hours = this.hours + 1
    }
    if (this.hours >= 24) {
      this.hours = this.hours - 24
      this.days = this.days + 1
    }
  }

  isCounting = () => this.status
  toggleStatus = () => {
    this.status = !this.status
    if (this.status) this.start()
    else this.stop()
  }

  count() {
    let time = this.secondsToCount
    if (time >= 60) {
      this.seconds = this.seconds + time % 60
      time = Math.floor(time / 60)

      if (time >= 60) {
        this.minutes = this.minutes + time % 60
        time = Math.floor(time / 60)

        if (time >= 24) {
          this.hours = this.hours + time % 24
          this.days = this.days + Math.floor(time / 60)

        } else{
          this.hours = this.hours + time
        }
      } else {
        this.minutes = this.minutes + time
      }
    } else this.seconds = this.seconds + time
    this.check()
  }

  start() {
    this.status = true
    this.clockCoutner = setInterval(() => {
      this.count()
    }, this.speedness())
  }

  stop() {
    this.status = false
    if (this.clockCoutner) clearInterval(this.clockCoutner);
  }

  speedness = () => 1000 / this.speed

  getTime = () => this

  getHours = () => {
    if (this.format === 1){
      if (this.hours > 12) return this.hours - 12
      if(this.hours === 0) return 12
    }
    return this.hours
  }

  getMinutes = () => this.minutes < 10 ? `0${this.minutes}` : this.minutes

  getSeconds = () => this.seconds < 10 ? `0${this.seconds}` : this.seconds

  getSecondsToCount = () => this.secondsToCount

  getFormat = () => this.format === 0 ? 'hrs' : this.hours >= 12 ? 'PM' : 'AM'

  getFormatNumber = () => this.format

  showTime = () => `${this.getHours()}:${this.getMinutes()}:${this.getSeconds()} ${this.getFormat()}`

  setSpeed(speed) {
    if (speed) this.speed = speed
  }

  setSecondsToCount(stc = 1) {
    this.secondsToCount = stc
  }

  setFormat(format) {
    this.format = format
  }

  setTime(seconds = 0, minutes = 0, hours = 0, format = 0, speed = 1) {
    this.seconds = seconds
    this.minutes = minutes
    this.hours = hours
    this.format = format
    this.speed = speed

    this.clockCoutner = null
  }
}

export default Clock
