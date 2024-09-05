import { CommonConstants } from '../../commom/constants/CommonConstants'
import cityPreferenceUtil from '../../commom/database/cityPreferenceUtil'
import City from '../../viewMainmodel/City'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'

@Component
export default struct showSearchResults {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @Link searchText: string
  @Link searchResults: City<WeatherInformation>[]


  build() {
    Column({ space: 10 }) {
      Text('搜索结果')
        .fontSize(14)
        .fontColor('#ff7c7878')
      List({ space: 5 }) {
        ForEach(this.searchResults, (city: City<WeatherInformation>) => {
          ListItem() {
            Row() {
              Text(city.name)
                .fontSize(20)
              Blank()
              Text(this.isCitySelected(city) ? '已添加' : '+')
                .fontSize(20)
                .fontColor(this.isCitySelected(city) ? '#999999' : '#ff226aea')
            }
            .width('100%')
            .padding(10)
            .onClick(() => {
              this.toggleCitySelection(city)
            })
          }
        })
      }
      .width('100%')
      .height('100%')
    }
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