class Clock {
  constructor(date = new Date(), format = 0, speed = 1, secondsToCount = 1) {
    this.date = new Date(date)
    this.format = format // 0: 24hrs | 1: 12hrs
    this.speed = speed
    this.secondsToCount = secondsToCount
    this.status = false

    this.clockCoutner = null

    this.updateTime()
  }

  isCounting = () => this.status
  toggleStatus = () => {
    this.status = !this.status
    if (this.status) this.start()
    else this.stop()
  }

  count() {
    this.date.setSeconds(this.date.getSeconds() + this.secondsToCount)
    this.updateTime()
  }

  updateTime() {
    this.seconds = this.date.getSeconds()
    this.minutes = this.date.getMinutes()
    this.hours = this.getHoursWithFormat()
    this.day = this.date.getDate ()
    this.weekDay =  this.weekDayToText(this.date.getDay())
    this.month = this.date.getMonth()
    this.monthText = this.monthToText(this.date.getMonth())
    this.year = this.date.getFullYear()
  }

  weekDayToText(number) {
    switch (number) {
      case 0:
        return 'Domingo'
        break
      case 1:
        return 'Lunes'
        break
      case 2:
        return 'Martes'
        break
      case 3:
        return 'Miércoles'
        break
      case 4:
        return 'Jueves'
        break
      case 5:
        return 'Viernes'
        break
      case 6:
        return 'Sábado'
        break
      default:

    }
  }

  monthToText(number) {
    switch (number) {
      case 0:
        return 'Enero'
        break
      case 1:
        return 'Febrero'
        break
      case 2:
        return 'Marzo'
        break
      case 3:
        return 'Abril'
        break
      case 4:
        return 'Mayo'
        break
      case 5:
        return 'Junio'
        break
      case 6:
        return 'Julio'
        break
      case 7:
        return 'Agosto'
        break
      case 8:
        return 'Septiembre'
        break
      case 9:
        return 'Octubre'
        break
      case 10:
        return 'Noviembre'
        break
      case 11:
        return 'Diciembre'
        break
      default: 'Desconocido'

    }
  }

  start() {
    this.status = true
    this.clockCoutner = setInterval(() => this.count(), this.speedness())
  }

  stop() {
    this.status = false
    if (this.clockCoutner) clearInterval(this.clockCoutner);
  }

  speedness = () => 1000 / this.speed

  getDate = () => this.date.getDate()
  getYear = () => this.date.getYear()
  getMonth = () => this.date.getMonth()
  getDay = () => this.date.getDay()


  getTime = () => this.date.getTime()
  getHours = () => this.date.getHours()
  getMinutes = () => this.date.getMinutes()
  getSeconds = () => this.date.getSeconds()

  getHoursWithFormat = () => {
    if (this.format === 1){
      if (this.date.getHours() > 12) return this.date.getHours() - 12
      if(this.date.getHours() === 0) return 12
    }
    return this.date.getHours()
  }

  getSecondsToCount = () => this.secondsToCount

  getFormat = () => this.format === 1 ? this.date.getHours() >= 12 ? 'PM' : 'AM' : 'hrs'

  getFormatNumber = () => this.format

  showTime = () => `${this.getHoursWithFormat()}:${this.date.getMinutes()}:${this.date.getSeconds()} ${this.getFormat()}`

  setSpeed(speed) {
    if (speed) this.speed = speed
  }

  setSecondsToCount(stc = 1) {
    this.secondsToCount = stc
  }

  setFormat(format) {
    this.format = format
    this.updateTime()
  }

  setTime(date, format = 0, speed = 1) {
    this.date = new Date(date)
    this.format = format
    this.speed = speed

    this.clockCoutner = null

    return this
  }
}

export default Clock
