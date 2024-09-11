
import httpModel from '../../commom/util/HttpModel'
import IndexBackgroundUtil from '../../commom/util/IndexBackgroundUtil'
import City from '../../viewMainmodel/City'
import ConditionInformation from '../../viewMainmodel/ConditionInformation'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import AirQualityInformation from '../CityWeatherInformation/AirQualityInformation'
import LifeIndexInformation from '../CityWeatherInformation/LifeIndexInformation'
import Weather24HourInformation from '../CityWeatherInformation/Weather24HourInformation'
import Weather7dInformation from '../CityWeatherInformation/Weather7dInformation'
import WeatherMainInformation from '../CityWeatherInformation/WeatherMainInformation'


@Component
export struct WeatherMainIndex {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = []
  @State hourWeather: WeatherInformation = new WeatherInformation()
  @State daysWeather: WeatherInformation = new WeatherInformation()
  @State warningCondition: ConditionInformation = new ConditionInformation()
  @State lifeIndexCondition: ConditionInformation = new ConditionInformation()
  @State airCondition: ConditionInformation = new ConditionInformation()
  @State myBackgroundImage: Resource = $r("app.media.background_loading")
  @Prop city: City<WeatherInformation> = new City('')
  @Prop index: number
  @State isLoading: boolean = false

  updateBackground() {
    const WeatherCondition = this.CityInformation[this.index].detail?.now?.text || '' //排除WeatherCondition为空的情况
    console.log('背景信息 ' + WeatherCondition)
    this.myBackgroundImage = IndexBackgroundUtil.getBackgroundImage(WeatherCondition)
  }

  async aboutToAppear(): Promise<void> {

    this.city = this.CityInformation[this.index]

    await httpModel.GetWeatherInformation<WeatherInformation>('weather', this.city.id, '24h').then((result) => {
      if (result.hourly) {
        this.hourWeather =
          new WeatherInformation(result.code, result.updateTime, result.fxLink, undefined, result.hourly,
            undefined,result.refer)
        console.log('天气信息小时成功' + JSON.stringify(this.hourWeather))
      }
    })

    await httpModel.GetWeatherInformation<WeatherInformation>('weather', this.city.id, '7d').then((result) => {
      if (result.daily) {
        this.daysWeather = new WeatherInformation(result.code, result.updateTime, result.fxLink, undefined,
          this.hourWeather.hourly, result.daily, result.refer)
        console.log('天气信息7天成功' + JSON.stringify(this.daysWeather))
      }
    })


    await httpModel.GetWeatherInformation<ConditionInformation>('indices', this.city.id, '1d',
      '1,2,3,4,6,8,9,15,16').then((result) => {
      if (result.daily) {
        this.lifeIndexCondition =
          new ConditionInformation(result.code, result.updateTime, result.fxLink, undefined, undefined,
            result.daily, result.refer)
        console.log('天气信息生活指数成功' + JSON.stringify(this.lifeIndexCondition))
      }
    })

    await httpModel.GetWeatherInformation<ConditionInformation>('warning', this.city.id, 'now').then((result) => {
      if (result.warning) {
        this.warningCondition =
          new ConditionInformation(result.code, result.updateTime, result.fxLink, result.warning, undefined, undefined,
            result.refer)
        console.log('天气信息预警成功' + JSON.stringify(this.warningCondition))
      }
    })

    await httpModel.GetWeatherInformation<ConditionInformation>('air', this.city.id, 'now').then((result) => {
      if (result.now) {
        this.airCondition =
          new ConditionInformation(result.code, result.updateTime, result.fxLink, this.warningCondition.warning,
            result.now, this.lifeIndexCondition.daily, result.refer)
        console.log('空气质量的天气信息成功' + JSON.stringify(this.airCondition))
      }
    })

    this.isLoading = true
    this.updateBackground()
  }

  build() {
    Column() {
      Stack() {
        Image(this.myBackgroundImage).objectFit(ImageFit.Cover) //背景图片的设置

        Column() {

          WeatherMainInformation({
            weatherMainInformation: this.city,
            daysWeather: this.daysWeather,
            airCondition: this.airCondition
          })

          Weather24HourInformation({hourWeather:this.hourWeather})

          Weather7dInformation({daysWeather:this.daysWeather})

          AirQualityInformation({airCondition:this.airCondition})

          LifeIndexInformation({lifeIndexCondition:this.lifeIndexCondition})

        }
        .width('100%')
        .padding(10)
      }
      .height('240%')
    }
    .width('100%')
  }
}