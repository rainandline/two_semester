import { getQualityAir } from '../viewmodel/getAirQulaity'
import { getLifeIndex } from '../viewmodel/getLifeIndex'
import { getReferInformation } from '../viewmodel/getReferInformation'
import getWarning from '../viewmodel/getWarning'

export default class ConditionInformation {
  code?: string
  updateTime?: string
  fxLink?: string
  warning?: getWarning[]
  now?: getQualityAir   //获取空气的质量
  daily?: getLifeIndex[]    //获取生活指数
  refer?: getReferInformation

  constructor(code?: string, updateTime?: string, fxLink?: string, warning?: getWarning[], now?: getQualityAir //获取空气的质量
    , daily?: getLifeIndex[] //获取生活指数
    , refer?: getReferInformation) {
    this.code = code
    this.updateTime = updateTime
    this.fxLink = fxLink
    this.warning = warning
    this.now = now
    this.daily = daily
    this.refer = refer
  }


}