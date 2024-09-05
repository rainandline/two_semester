import { getCurrentWeather } from '../viewmodel/getCurrentWeather'
import { getLocationInformation } from '../viewmodel/getLocationInformation'
import { getNowdayWeather } from '../viewmodel/getNowdayWeather'
import { getReferInformation } from '../viewmodel/getReferInformation'
import { getWeatherInformation } from '../viewmodel/getWeatherInformation'


//用于标记类的属性或函数参数为可选的
//增加灵活性   简化代码和提高可读性   类型安全,成功的通过编译

export default class WeatherInformation {

  code?: string
  updateTime?: string
  fxLink?: string
  now?: getCurrentWeather   //获取当前的天气状态
  hourly?: getNowdayWeather[]    //获取24h的天气状态
  daily?: getWeatherInformation[]  //获取7d的天气状态
  refer?: getReferInformation

  constructor(code?: string, updateTime?: string, fxLink?: string, now?: getCurrentWeather //获取当前的天气状态
    , hourly?: getNowdayWeather[] //获取24h的天气状态
    , daily?: getWeatherInformation[] //获取7d的天气状态
   , refer?: getReferInformation) {
    this.code = code
    this.updateTime = updateTime
    this.fxLink = fxLink
    this.now = now
    this.hourly = hourly
    this.daily = daily

    this.refer = refer
  }




}