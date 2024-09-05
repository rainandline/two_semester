import CityMangerDisplay from '../view/CityMangerPage/CityMangerDisplay'
import CityNavigationHeader from '../view/CityMangerPage/CityNavigationHeader'
import City from '../viewMainmodel/City'
import WeatherInformation from '../viewMainmodel/WeatherInformation'


@Entry
@Component
struct CityMangerPage {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @State LoadingCityInformation: boolean = false

  //初始判断是否加载城市的信息初始化成功
  aboutToAppear() {
    if (this.CityInformation) {
      this.LoadingCityInformation = true
    }
  }

  build() {
    Column() {

      //1. 导航栏
      CityNavigationHeader()

      //2. 城市的列表展示
      if(this.LoadingCityInformation) {
        CityMangerDisplay()
      } else {
        Image($r('app.media.background_loading')).width('100%').height('100%').objectFit(ImageFit.Cover)
      }

    }
    .height('100%')
    .width('100%')
    .padding(10)
  }
}