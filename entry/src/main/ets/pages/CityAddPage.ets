import { CommonConstants } from '../commom/constants/CommonConstants'
import cityPreferenceUtil from '../commom/database/cityPreferenceUtil'
import CityAddHeader from '../view/CityAddPage/CityAddHeader'
import CityAddHotCity from '../view/CityAddPage/CityAddHotCity'
import CityAddSearchHeader from '../view/CityAddPage/CityAddSearchHeader'
import showSearchResults from '../view/CityAddPage/showSearchResults'

import City from '../viewMainmodel/City'
import SearchLocationInformation from '../viewMainmodel/SearchLocationInformation'
import WeatherInformation from '../viewMainmodel/WeatherInformation'
import { getLocationInformation } from '../viewmodel/getLocationInformation'

@Entry
@Component
struct CityAddPage {

  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @State searchText: string = ''
  @State searchResults: City<WeatherInformation>[] = []
  @StorageLink('isSearch') isSearch: boolean = false


  build() {
    Column({ space: 15 }) {

      // 1. 城市添加的导航栏
      CityAddHeader()

      // 2. 城市添加的搜索栏
      CityAddSearchHeader({ searchText: this.searchText, searchResults: this.searchResults })

      //3.热门城市和搜索城市的展示
      if (!this.isSearch) {
        CityAddHotCity()
      }
      if(this.searchResults.length > 0 && this.isSearch==true) {
        showSearchResults({ searchText: this.searchText, searchResults: this.searchResults })
      }
    }
    .height('100%')
    .width('100%')
    .padding(10)
  }

}

