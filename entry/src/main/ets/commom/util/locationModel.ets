

import { geoLocationManager } from '@kit.LocationKit';
import { promptAction } from '@kit.ArkUI';
import HttpModel from './HttpModel';
import WeatherInformation from '../../viewMainmodel/WeatherInformation';
import City from '../../viewMainmodel/City';


class Location{
  latitude:number//纬度
  longitude:number//经度

  constructor(latitude: number, longitude: number) {
    this.latitude = latitude;
    this.longitude = longitude;
  }
}


class LocationModel {
  async getCurrentLocation(): Promise<Location> {
    //初始化的位置信息
    let loc: Location = new Location(0, 0)
    //进行位置的请求
    let request: geoLocationManager.SingleLocationRequest = {
      locatingPriority: 0x502,
      locatingTimeoutMs: 10000
    }
    await geoLocationManager.getCurrentLocation(request).then((result) => {
      console.log('当前的城市定位' + JSON.stringify(result))
      loc = new Location(result.latitude, result.longitude)
    }).catch((err: Error) => {
      promptAction.showToast({
        message: JSON.stringify(err),
        duration: 2000
      })
    })
    console.log(JSON.stringify(loc))
    return loc
  }

  async getCityInformation(latitude: number, longitude: number): Promise<City<WeatherInformation>> {
    let CurrentCity: City<WeatherInformation> = new City<WeatherInformation>('','')
    const location = `${longitude.toFixed(2)},${latitude.toFixed(2)}`
    await HttpModel.GetCityInformation(location).then(city => {
      if(city.length>0) {
        CurrentCity = city.shift()!   //! 断言操作符需要确保 city 数组确实包含至少一个元素
      }
    })
    return CurrentCity
  }

  async getCityCode(): Promise<City<WeatherInformation>> {
    try {
      const location: Location = await this.getCurrentLocation()
      return await this.getCityInformation(location.latitude, location.longitude)
    } catch (error) {
      console.error('Failed to get current city info:', error);
      throw new Error(error)
    }
  }
}

const locationModel = new LocationModel()
export default locationModel as LocationModel