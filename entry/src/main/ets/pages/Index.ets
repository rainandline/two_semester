


import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { WeatherMainIndex } from '../view/MainView/WeatherMainIndex';
import City from '../viewMainmodel/City';
import WeatherInformation from '../viewMainmodel/WeatherInformation';
import locationModel from '../commom/util/locationModel';
import cityPreferenceUtil from '../commom/database/cityPreferenceUtil';
import { CommonConstants } from '../commom/constants/CommonConstants';
import HttpModel from '../commom/util/HttpModel';
import IndexBackgroundUtil from '../commom/util/IndexBackgroundUtil';
import TopNavBar from '../view/MainView/TopNavBar';


//请求定位的权限
const permissions: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];

// 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {

  // 1. 创建权限的管理器，处理用户间的相关权限
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

  // 2. requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        return;
      }
    }
    // 授权成功继续进行如下的操作
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}


@Entry
@Component
struct Index {

  //@Watch应用于对状态变量的监听。如果需要关注某个状态变量的值是否改变，可以使用@Watch为状态变量设置回调函数。
  @State @Watch('updateBackground') myBackgroundImage: Resource = $r("app.media.background_loading")
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = [] //城市的代码集合
  @StorageLink('CurrentCityIndex') CurrentCityIndex: number = 0
  @State judge: boolean = true
  private swiperController: SwiperController = new SwiperController()

  async onPageShow(): Promise<void> {
    if (this.judge) {
      await this.loadCityInformation()
      this.judge = false
      AppStorage.setOrCreate('CityInformation', this.CityInformation)
    }
    this.updateBackground()
  }

  updateBackground() {
    const WeatherCondition =
      this.CityInformation[this.CurrentCityIndex].detail?.now?.text || '' //排除WeatherCondition为空的情况
    console.log('背景信息 ' + WeatherCondition)
    this.myBackgroundImage = IndexBackgroundUtil.getBackgroundImage(WeatherCondition)
  }

  async loadCityInformation() {
    try {
      const currentCity = await locationModel.getCityCode() //获取当前的位置
      const PauseCityInformation = await cityPreferenceUtil.getAllCities(CommonConstants.CITY_INFO) //加载首选项中的数据
      const currentCityExists = PauseCityInformation.some(city => city.id === currentCity.id) //判断里面是否已经添加了数据
      if (!currentCityExists) {
        PauseCityInformation.unshift(currentCity)
      }
      let data = PauseCityInformation.map(async city => {
        let NowWeather: WeatherInformation =
          await HttpModel.GetWeatherInformation('weather', city.id, 'now') as WeatherInformation
        console.log('天气信息当前成功' + JSON.stringify(NowWeather))
        return new City(city.name, city.id, NowWeather)
      })
      this.CityInformation = await Promise.all(data)
      await cityPreferenceUtil.putCity(CommonConstants.CITY_INFO, currentCity.name, currentCity.id)
    } catch (error) {
      console.error('Failed to load city data:', error);
    }
  }

  build() {
    Column() {
      if (this.CityInformation.length > 0) {
        //1. 主页面的内容
        Swiper(this.swiperController) {
          ForEach(this.CityInformation, (city: City<WeatherInformation>, index) => {
            List(){
              WeatherMainIndex({ city: city, index: index })
            }
            .width('100%')
            .height('100%')
          })
        }
        .loop(true)
        .width('100%')
        .indicator(false)
        .index(this.CurrentCityIndex)
        .onChange((index: number) => {
          this.CurrentCityIndex = index
        })

        //2. 头部的导航栏
        TopNavBar()
      } else {
        Column() {
          Image($r('app.media.background_loading')).objectFit(ImageFit.Cover)
        }
      }
    }
  }
}



