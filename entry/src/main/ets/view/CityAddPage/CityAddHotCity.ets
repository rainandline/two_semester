import { CommonConstants } from '../../commom/constants/CommonConstants'
import cityPreferenceUtil from '../../commom/database/cityPreferenceUtil'

import City from '../../viewMainmodel/City'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'

@Component
export default struct CityAddHotCity {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @State RecommendCities: City<WeatherInformation>[] = [
    new City('北京', '101010100'),
    new City('上海', '101020100'),
    new City('深圳', '101280601'),
    new City('广州', '101280101'),
    new City('武汉', '101200101'),
    new City('长沙', '101250101'),
    new City('南京', '101190101'),
    new City('苏州', '101190401'),
    new City('西安', '101110101'),
    new City('济南', '101120101'),
    new City('青岛', '101120201'),
    new City('沈阳', '101070101'),
    new City('重庆', '101040100'),
    new City('郑州', '101180101'),
    new City('成都', '101270101'),
    new City('杭州', '101210101'),
    new City('厦门', '101230201'),
    new City('长春', '101060101'),
    new City('昆明', '101290101'),
    new City('秦皇岛', '101091101'),
    new City('南昌', '101240101'),
    new City('石家庄', '101090101'),
    new City('千阳', '101110903'),
    new City('未央区', '101110112')
  ]

  build() {
    Scroll() {
      Grid() {
        ForEach(this.RecommendCities, (HotCity: City<WeatherInformation>) => {
          GridItem() {
            Text(HotCity.name)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .height(80)
              .fontColor(this.isCitySelected(HotCity) ? '#999999' : Color.Black)
          }
          .onClick(()=>{
            this.toggleCitySelection(HotCity)
          })
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
    }
    .width('100%')
  }

  isCitySelected(city: City<WeatherInformation>): boolean {
    return this.CityInformation.some(c => c.id === city.id)
  }

  toggleCitySelection(city: City<WeatherInformation>) {
    if (this.isCitySelected(city)) {
      this.CityInformation = this.CityInformation.filter(c => c.id !== city.id)
      cityPreferenceUtil.removeCity(CommonConstants.CITY_INFO, city.name)
    } else {
      this.CityInformation.push(city)
      cityPreferenceUtil.putCity(CommonConstants.CITY_INFO, city.name, city.id)
    }
  }
}