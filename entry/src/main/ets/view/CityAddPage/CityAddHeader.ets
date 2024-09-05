import { router } from '@kit.ArkUI'

@Component
export default struct  CityAddHeader {

  @StorageLink('isSearch') isSearch: boolean = false

  build() {
    Row() {
      Row({ space: 23 }) {
        Image($r('app.media.CityMangerPages_back')).width(30).margin({ left: 10 })
        .onClick(() => {
          AppStorage.set('isSearch', false)
          router.pushUrl({
            url: "pages/Index",
          },
            err => { //配置错误的信息
            if (err) {
              console.log(`路由失败，err:${err.code} errMsg:${err.message}`)
            }
          })
          })
        Text('添加城市').fontSize(25).fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
    .margin({ top: 15 })
  }
}