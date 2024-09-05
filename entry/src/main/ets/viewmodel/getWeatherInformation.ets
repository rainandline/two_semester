


export class getWeatherInformation {
  fxDate: string
  sunrise: string
  sunset: string
  moonrise: string
  moonset: string
  moonPhase: string
  moonPhaseIcon: string   //月像的图标代码

  tempMax: string
  tempMin: string

  iconDay: string   //预报白天天气状况的图标代码
  textDay: string   //预报白天天气状况文字描述
  iconNight: string   //预报夜间天气状况的图标代码
  textNight: string   //预报晚间天气状况文字描述

  wind360Day: string
  windDirDay: string
  windScaleDay: string
  windSpeedDay: string
  wind360Night: string
  windDirNight: string
  windScaleNight: string
  windSpeedNight: string
  humidity: string
  precip: string
  pressure: string

  vis: string
  cloud: string
  uvIndex: string

  constructor(fxDate: string, sunrise: string, sunset: string, moonrise: string, moonset: string, moonPhase: string,
    moonPhaseIcon: string //月像的图标代码
    , tempMax: string, tempMin: string, iconDay: string //预报白天天气状况的图标代码
    , textDay: string //预报白天天气状况文字描述
    , iconNight: string //预报夜间天气状况的图标代码
    , textNight: string //预报晚间天气状况文字描述
    , wind360Day: string, windDirDay: string, windScaleDay: string, windSpeedDay: string, wind360Night: string,
    windDirNight: string, windScaleNight: string, windSpeedNight: string, humidity: string, precip: string,
    pressure: string, vis: string, cloud: string, uvIndex: string) {
    this.fxDate = fxDate
    this.sunrise = sunrise
    this.sunset = sunset
    this.moonrise = moonrise
    this.moonset = moonset
    this.moonPhase = moonPhase
    this.moonPhaseIcon = moonPhaseIcon
    this.tempMax = tempMax
    this.tempMin = tempMin
    this.iconDay = iconDay
    this.textDay = textDay
    this.iconNight = iconNight
    this.textNight = textNight
    this.wind360Day = wind360Day
    this.windDirDay = windDirDay
    this.windScaleDay = windScaleDay
    this.windSpeedDay = windSpeedDay
    this.wind360Night = wind360Night
    this.windDirNight = windDirNight
    this.windScaleNight = windScaleNight
    this.windSpeedNight = windSpeedNight
    this.humidity = humidity
    this.precip = precip
    this.pressure = pressure
    this.vis = vis
    this.cloud = cloud
    this.uvIndex = uvIndex
  }
}