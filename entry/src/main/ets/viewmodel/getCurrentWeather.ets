

export class getCurrentWeather{
  obsTime: string  //数据观测时间
  temp: string
  feelsLike: string   //体感温度
  icon: string        //天气状况的图标代码
  text: string        //天气状况的文字描述，包括阴晴雨雪等天气状态的描述
  wind360: string     
  windDir: string
  windScale: string
  windSpeed: string
  humidity: string
  precip: string
  pressure: string
  vis: string
  cloud: string
  dew: string

  constructor(obsTime: string, temp: string, feelsLike: string, icon: string, text: string, wind360: string,
    windDir: string, windScale: string, windSpeed: string, humidity: string, precip: string, pressure: string,
    vis: string, cloud: string, dew: string) {
    this.obsTime = obsTime
    this.temp = temp
    this.feelsLike = feelsLike
    this.icon = icon
    this.text = text
    this.wind360 = wind360
    this.windDir = windDir
    this.windScale = windScale
    this.windSpeed = windSpeed
    this.humidity = humidity
    this.precip = precip
    this.pressure = pressure
    this.vis = vis
    this.cloud = cloud
    this.dew = dew
  }


}