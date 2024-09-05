import { CommonConstants } from '../../commom/constants/CommonConstants'
import HttpModel from '../../commom/util/HttpModel'
import IndexBackgroundUtil from '../../commom/util/IndexBackgroundUtil'
import City from '../../viewMainmodel/City'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { router } from '@kit.ArkUI'
import cityPreferenceUtil from '../../commom/database/cityPreferenceUtil'

@Component
export default struct CityMangerDisplay {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @StorageLink('CurrentCityIndex') CurrentCityIndex: number = 0
  @State isLoading: boolean = false

  async aboutToAppear(): Promise<void> {
    this.isLoading = false
    await this.loadCities()
  }

  //加载城市列表的天气信息
  async loadCities() {
    let CityMangerWeather: WeatherInformation = new WeatherInformation()
    for (let i = 0; i < this.CityInformation.length; i++) {
      if (this.CityInformation[i].id != undefined) {
        CityMangerWeather = await HttpModel.GetWeatherInformation('weather', this.CityInformation[i].id, "now")
        this.CityInformation[i].detail = CityMangerWeather
      }
    }
    this.isLoading = true
  }

  build() {
    if (this.isLoading) {
      List({ space: 13 }) {
        ForEach(this.CityInformation, (city: City<WeatherInformation>, index) => {
          ListItem() {
            Row() {
              Text(city.name).fontSize(24).fontColor(Color.White).fontWeight(FontWeight.Bold).padding({ left: 20 })
              Blank()
              Column({ space: 20 }) {
                if (city.detail) {
                  Text(`${city.detail.now?.temp}°`)
                    .fontSize(20)
                    .fontWeight(CommonConstants.FONT_WEIGHT_700)
                    .fontColor(Color.White)
                  Text(city.detail.now?.text).fontSize(14).fontColor(Color.White)
                }
              }.padding({ right: 20 })
            }
            .width('100%')
            .height('14%')
            .borderRadius(15)
            .backgroundImage(IndexBackgroundUtil.getBackgroundImage(city.detail?.now?.text || ''))
            .backgroundImageSize(ImageSize.Cover)
          }
          .swipeAction(city.name==='长安'? {end: this.noDelete()} : {end: this.deleteButton(city.name)})
          .onClick(()=>{
            this.CurrentCityIndex=index
            router.replaceUrl({url:'pages/Index'})
          })
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 20, bottom: 20 })
    } else {
      Image($r('app.media.background_loading')).width('100%').height('100%').objectFit(ImageFit.Cover)
    }
  }

  @Builder
  noDelete() {
    Image($r('app.media.delete_icon'))
      .fillColor(Color.Gray)
      .width('20')
      .height('20')
      .margin({left:20})

  }

  //删除一个城市
  @Builder
  deleteButton(name: string){
    Image($r('app.media.delete_icon'))
      .fillColor(Color.Red)
      .width('20')
      .height('20')
      .margin({left:20})
      .onClick( () => {
        this.CityInformation = this.CityInformation.filter(c => c.name !== name)
        cityPreferenceUtil.removeCity(CommonConstants.CITY_INFO, name)
      })
  }
}