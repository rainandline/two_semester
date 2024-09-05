

import { router } from '@kit.ArkUI'
import City from '../../viewMainmodel/City'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { url } from '@kit.ArkTS'
import { CommonConstants } from '../../commom/constants/CommonConstants'

@Component
export default struct TopNavBar {
  @StorageLink('CityInformation') CityInformation: City<WeatherInformation>[] = [] //城市的代码集合
  @StorageLink('CurrentCityIndex') CurrentCityIndex: number = 0

  build() {
    if(this.CityInformation[this.CurrentCityIndex].name) {
      Row() {
        Row({ space: 7 }) {
          Text(this.CityInformation[this.CurrentCityIndex].name)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
        .padding({left:10})

        Image($r('app.media.three_dots')).height(30).padding({ right: 20 })
          .onClick(() => {
            router.pushUrl({
              //目标页面不会替换当前页，而是压入页面栈
              url: "pages/CityMangerPage"   //配置页面的跳转
            },
              router.RouterMode.Single, //单实例模式。如果目标页面的url已经存在于页面栈中，则会将离栈顶最近的同url页面移动到栈顶，该页面成为新建页
              err => { //配置错误的信息
                if (err) {
                  console.log(`路由失败，err:${err.code} errMsg:${err.message}`)
                }
              })
          })
      }.width('100%').height(CommonConstants.TOPIC_HEIGHT).position({ x: 0, y: 0 })
    }
  }
}