import { CommonConstants } from '../../commom/constants/CommonConstants'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { getNowdayWeather } from '../../viewmodel/getNowdayWeather'

@Component
export default struct Weather24HourInformation {
  @Prop hourWeather: WeatherInformation
  @State isShow: boolean = false
  @State hourSelectIndex:number = 0

  //对于最高气温和最低气温的描绘，创建对象
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Scroll() {
      Row({ space: 30 }) {
          ForEach(this.hourWeather.hourly, (data: getNowdayWeather) => {
            ListItem() {
              Column({ space: 20 }) {
                Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`).fontSize(16).fontColor(Color.White).fontWeight(500)
                Image($r(`app.media.${data.icon}`)).width(30).height(30).fillColor(Color.White)
                Text(`${data.temp}°`).fontSize(20).fontWeight(500).fontColor(Color.White)
              }
            }
          })
      }
    }
    .width('100%')
    .height(145)
    .backgroundColor("#2a000000")
    .backgroundBlurStyle(BlurStyle.Thin)
    .borderRadius(10)
    .margin({ top: 20 })
    .padding({ left: 20, right: 20, top: 10, bottom: 10 })
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .onClick(()=>{this.isShow=!this.isShow})
    .bindSheet(this.isShow,this.Weather24hPicture(),{
      detents: [700],
      backgroundColor: Color.White,
      blurStyle: BlurStyle.Thick,
      showClose: true,
      enableOutsideInteractive: false,
      dragBar: true
    })
  }


  @Builder Weather24hPicture() {
    Column() {
      Text('24小时天气详情')
        .fontSize(18)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
      Scroll(){
        Column(){
          Canvas(this.context)
            .width('400%')
            .height(150)
            .onReady(() => {
              this.drawLineChart()
            })
            .margin({top:20})
          Row() {
            ForEach(this.hourWeather.hourly, (data: getNowdayWeather, index: number) => {
              Column() {
                Column({ space: 5 }) {
                  Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`)
                    .fontSize(14)
                  Image($r(`app.media.${data.icon}`))
                    .width(24)
                    .height(24)
                  Text(`${data.temp}°`)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                  Text(`${data.windDir}`)
                    .fontSize(12)
                  Text(`${data.windScale}级`)
                    .fontSize(12)
                }
                .width((1422.77) / 24)
                .height(120)
              }
              .onClick(() => {
                this.hourSelectIndex = index
              })
              .backgroundColor( this.hourSelectIndex === index ? "#41858383" : "#f1f3f5")

            })
          }
          .width('400%')
          .height(120)
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)


      // 小时的具体信息
      Grid() {
        if( this.hourWeather.hourly){
          GridItem() {
            Column() {
              Text('大气压强').fontSize(14).fontColor("#FF8D8D8F")
              Text(`${this.hourWeather.hourly[this.hourSelectIndex].pressure}千帕`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }

          GridItem() {
            Column() {
              Text('降水概率').fontSize(14).fontColor("#FF8D8D8F")
              Text(`${this.hourWeather.hourly[this.hourSelectIndex].pop}%`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }

          GridItem() {
            Column() {
              Text('湿度').fontSize(14).fontColor("#FF8D8D8F")
              Text(`${this.hourWeather.hourly[this.hourSelectIndex].humidity}%`).fontSize(18).fontWeight(FontWeight.Bold)
            }
          }
        }
      }
      .width('100%')
      .height(100)
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr')
      .padding({ top: 5 })

    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#F1F3F5')
    .borderRadius(16)
  }

  drawLineChart() {
    if (!this.hourWeather.hourly || this.hourWeather.hourly?.length === 0) {
      console.log('No data available for drawing chart')
      return
    }
    //canvas的宽高
    const width = this.context.width
    const height = this.context.height
    const padding: GeneratedObjectLiteralInterface_1 = { top: 40, bottom: 10, left: 15, right: 15 }
    const dataPoints = this.hourWeather.hourly!.map(item => Number(item.temp))
    const maxTemp = Math.max(...dataPoints)
    const minTemp = Math.min(...dataPoints)

    console.log('TestTag'+maxTemp+minTemp)

    // 清除画布
    this.context.clearRect(0, 0, width, height)

    // 绘制折线
    this.context.beginPath()
    this.context.strokeStyle = Color.Red
    this.context.lineWidth = 3
    console.log('testTag width和height', this.context.width, this.context.height)
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y =
        height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))
      console.log('tesTag x,y的值：', x, y)
      if (index === 0) {
        //初始点
        this.context.moveTo(x, y)
      } else {
        //连接
        this.context.lineTo(x, y)
      }
    })
    //进行边框绘制
    this.context.stroke()

    // 绘制数据点和温度标注
    this.context.textAlign = 'center'
    this.context.font = '62px sans-serif'
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y =
        height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))

      // 绘制数据点
      this.context.beginPath()
      //绘制弧线路径
      this.context.arc(x, y, 4, 0, 2 * Math.PI)
      this.context.fillStyle = Color.Red
      this.context.fill()

      // 绘制温度标注
      this.context.fillStyle = '#333333'
      this.context.fillText(`${temp}°`, x, y - 15)
    })
  }
}

interface GeneratedObjectLiteralInterface_1 {
  left: number;
  right: number;
  top: number;
  bottom: number;
}

//时间格式化
function extractTime(dateTimeString: string): string {
  const regex = /T(\d{2}:\d{2})/;
  const match = dateTimeString.match(regex);
  return match ? match[1] : '';
}