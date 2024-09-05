import { router } from '@kit.ArkUI'

@Component

export default struct  CityNavigationHeader {
  build() {
    Row() {
      Row({ space: 23 }) {
        Image($r('app.media.CityMangerPages_back')).width(30).margin({ left: 10 }).fillColor(Color.Black)
          .onClick(() => {
            router.back() //返回到上一页
          })
        Text('城市管理').fontSize(25).fontColor(Color.Black).fontWeight(FontWeight.Bold)
      }

      Blank() //Blank父组件未设置宽度时,blank的设置为无效的状态
      Image($r('app.media.CityMangerPages_add')).width(30).fillColor(Color.Black).onClick(() => {
        router.pushUrl({
          url: "pages/CityAddPage"
        },
          router.RouterMode.Single, //单实例模式。如果目标页面的url已经存在于页面栈中，则会将离栈顶最近的同url页面移动到栈顶，该页面成为新建页
          err => { //配置错误的信息
            if (err) {
              console.log(`路由失败，err:${err.code} errMsg:${err.message}`)
            }
          })
      })
    }
    .width('100%')
    .margin({ top: 15 })
  }
}