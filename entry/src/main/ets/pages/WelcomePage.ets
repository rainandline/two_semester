

import { CommonConstants } from '../commom/constants/CommonConstants'
import { router } from '@kit.ArkUI'

@Extend(Text) function SettingWelcomePage(opacity: number,fontsize:number){
  .fontSize(fontsize)
  .opacity(opacity)
  .fontColor(Color.Black)
}

@Entry
@Component
struct WelcomePage {

  aboutToAppear(): void {
    this.jumpToIndex()
  }

  //目标页面会替换当前页，并销毁当前页,应为Welcome页面只需要出现一次
  jumpToIndex(){
    //设置进入的延迟时间
    setTimeout(()=>{
      router.replaceUrl({
        url:'pages/Index'
      })
    },2000)  //2秒以后进行跳转
  }

  build() {
    Column({ space: 12 }) {

      //1. 中央的logo设计
      Row() {
        Image($r('app.media.Weather_logo')).width(350)
      }.layoutWeight(1)

      Row({ space: 10 }) {
        Image($r('app.media.qweather')).width(50)
        Image($r('app.media.Weather_logo_writing')).width(200)
      }

      Text('由隐墨公司进行出版发行，一切版权归隐墨公司').SettingWelcomePage(0.6,12)
      Text('陕ICP备6666666号').SettingWelcomePage(0.4,12)
    }
    .width(CommonConstants.THOUSANDTH_1000)
    .height(CommonConstants.THOUSANDTH_1000)
    .backgroundImage($r('app.media.Weather_logo_background'))
    .backgroundImageSize(ImageSize.Cover)
    .padding({ bottom: 25 })
  }
}