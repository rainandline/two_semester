import { CommonConstants } from '../../commom/constants/CommonConstants'
import ConditionInformation from '../../viewMainmodel/ConditionInformation'
import { getLifeIndex } from '../../viewmodel/getLifeIndex'

@Component
export default struct LifeIndexInformation {
  @Prop lifeIndexCondition: ConditionInformation
  @State isShow2: boolean = false
  @State currentIndex:number = 0

  build() {

    Column() {
      Row() {
        Text('生活建议')
          .fontSize(19).fontColor(Color.White)
        Text('>')
          .fontSize(25).fontColor(Color.White)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 15, right: 15 })

      Divider()

      Grid() {
        ForEach(this.lifeIndexCondition.daily, (data: getLifeIndex) => {
          GridItem() {
            this.Card($r(`app.media.life${data.type}`), data.name, data.category)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')

    }
    .padding({ bottom: 20, top: 10 })
    .margin({ top: 30 })
    .width('100%')
    .borderRadius(10)
    .height(550)
    .backgroundColor("#2a000000")
    .backgroundBlurStyle(BlurStyle.Thin)
    .onClick(() => {
      this.isShow2 = !this.isShow2
    })
    .bindSheet(this.isShow2, this.tipsBuilderLifeAdvice(this.lifeIndexCondition), {
      detents: [700],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick
    })
  }

  //模态框
  @Builder
  tipsBuilderLifeAdvice(otherItem: ConditionInformation){
    Column({space:20}){
      Column({space:10}){
        if(otherItem.daily){
          Text(otherItem.daily[this.currentIndex].name)
            .fontSize(24)
            .fontWeight(CommonConstants.FONT_WEIGHT_600)
          Image($r(`app.media.life${otherItem.daily[this.currentIndex].type}`))
            .height(100)
            .width(100)
          Text(otherItem.daily[this.currentIndex].text)
            .fontSize(16)

        }
      }
      .height(250)
      .padding(10)
      .width('100%')
      .backgroundColor('#ffd6d6d6')
      .borderRadius(10)

      Text('其他建议')
        .fontSize(20)
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
      Scroll(){
        Grid(){
          ForEach(otherItem.daily, (data:getLifeIndex, index: number) => {
            GridItem(){
              this.lifeCard($r(`app.media.life${data.type}`), data.name, data.category)
            }
            .padding(10)
            .margin(5)
            .borderRadius(10)
            .backgroundColor(this.currentIndex === index ? '#8084c4e7' : '#ffd6d6d6')
            .onClick( () => {
              this.currentIndex = index
            })
          })
        }
        .rowsTemplate('1fr')
        .borderRadius(10)

      }
      .width('200%')
      .height(120)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .backgroundColor('#ffefecec')
    .padding(10)
    .margin({top:20})
    .width('100%')
  }

  //主页面的生活建议Card
  @Builder Card(image:Resource,title:string, text:string){
    Column({space:20}){
      Text(title)
        .fontSize(18)
        .fontColor(Color.White)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Image(image)
        .width(40)
        .height(40)
      Text(text)
        .fontSize(20)
        .fontWeight(CommonConstants.FONT_WEIGHT_500).fontColor(Color.White)
    }
    .padding(10)
  }


  @Builder lifeCard(image:Resource,title:string, text:string){
    Column({space:10}){
      Text(title)
        .fontSize(14)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Image(image)
        .width(30)
        .height(30)
      Text(text)
        .fontSize(16)
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
    }
    .borderRadius(10)

  }
}

