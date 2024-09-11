import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { getWeatherInformation } from '../../viewmodel/getWeatherInformation';


//格式化时间
function formatDate(dateString: string): string {
  //正则表达提取年月日，从服务端拿到的数据为  2021-11-15
  const regex = /(\d{4})-(\d{2})-(\d{2})/

  // match的值为 2024-09-04,2024,09,04
  const match = dateString.match(regex)

  //异常的处理判断
  if (match && match.length === 4) {
    const month = parseInt(match[2])
    const day = parseInt(match[3])
    return `${month}月${day}日`
  }
  //不符合预期直接原路打回
  return dateString
}


//格式化星期
function getDayDescription(dateString: string): string {

  // 当前日期和时间
  const today = new Date()

  // 创建目标的时间
  const targetDate = new Date(dateString)

  //计算targetDate和today之间的时间差（单位为毫秒），
  //然后除以一天的毫秒数（1000毫秒 * 60秒 * 60分钟 * 24小时），得到天数的差值
  //最后使用Math.floor对结果进行向下取整，得到两日期之间的完整天数差。
  const diffDays = Math.floor((targetDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays === -1) return '今天';
  if (diffDays === 0) return '明天';

  // 内置函数可以判断星期
  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  return weekdays[targetDate.getDay()];
}


@Component
export default struct Weather7dInformation {

  @Prop @Watch('onDaysWeatherChange') daysWeather: WeatherInformation

  onDaysWeatherChange(newVal: WeatherInformation) {
    if (newVal) {
      this.drawLineChart1(); // 调用第一个方法
      this.drawLineChart2(); // 调用第二个方法
    }
  }

  //对于最高气温和最低气温的描绘，创建两个对象
  private settings_1: RenderingContextSettings = new RenderingContextSettings(true);
  private context_1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings_1);
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Scroll() {
      Column({space:10}) {
        Row({ space: 25 }) {
          ForEach(this.daysWeather.daily, (data: getWeatherInformation) => {
            Column({ space: 6 }) {
              Text(getDayDescription(data.fxDate!)).fontSize(14).fontWeight(500).fontColor(Color.White)
              Text(`${data.fxDate ? formatDate(data.fxDate) : ''}`).fontSize(14).fontColor(Color.White).fontWeight(500)
              Image($r(`app.media.${data.iconDay}`)).width(30).height(30).fillColor(Color.White)
              Text(`${data.textDay}`).fontSize(14).fontWeight(500).fontColor(Color.White)
            }
          })
        }
        .height(90)
        .layoutWeight(1)

        Column(){
          Canvas(this.context_1)
            .width(480)
            .height(120)
            .onReady(() => {
              if (this.daysWeather.daily && this.daysWeather.daily.length > 0) {
                this.drawLineChart1();
              }
            })
        }
        Column(){
          Canvas(this.context)
            .width(480)
            .height(120)
            .onReady(() => {
              if (this.daysWeather.daily && this.daysWeather.daily.length > 0) {
                this.drawLineChart2();
              }
            })
        }
      }

    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .backgroundColor("#2a000000")
    .borderRadius(10)
    .margin({ top: 20 })
    .height(370)
    .padding({ top: 10, bottom: 10, left: 15, right: 15 })
    .backgroundBlurStyle(BlurStyle.Thin)
  }

  drawLineChart1() {

    //如果判断为空可以直接跳出绘图函数
    if (!this.daysWeather.daily || this.daysWeather.daily.length === 0) {
      console.log('No data available for drawing chart')
      return
    }

    //canvas的宽高
    const width = this.context_1.width
    const height = this.context_1.height
    const padding: GeneratedObjectLiteralInterface_1 = { top: 30, bottom: 15, left: 15, right: 15 }
    const dataPoints = this.daysWeather.daily!.map(item => Number(item.tempMax))  //对于绘制信息的获取
    const maxTemp = Math.max(...dataPoints)  //最高气温
    const minTemp = Math.min(...dataPoints)  //最低气温

    // 清除画布
    this.context_1.clearRect(0, 0, width, height)

    // 绘制折线
    this.context_1.beginPath()
    this.context_1.strokeStyle = Color.White   //绘制折现的颜色
    this.context_1.lineWidth = 3
    console.log('testTag width和height', this.context_1.width, this.context_1.height)
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y =
        height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))
      console.log('tesTag x,y的值：', x, y)
      if (index === 0) {
        //初始点,用于在画布上开始一条新的路径或移动路径到一个新的起点。它不会在画布上绘制任何东西，而是将“笔”移动到指定的坐标上。
        this.context_1.moveTo(x, y)
      } else {
        //连接,意味着从第二个点开始，每次调用都会在画布上画一条线，连接前一个点和当前点。
        this.context_1.lineTo(x, y)
      }
    })

    //进行边框绘制,可能已经使用moveTo和lineTo定义了一个或多个路径，stroke方法会将这些路径以线条的形式绘制在画布上。
    this.context_1.stroke()

    // 绘制数据点和温度标注
    this.context_1.textAlign = 'center'   //以指定的坐标为中心点进行渲染。
    this.context_1.font = '55px sans-serif'   //大小为46像素，字体为无衬线字体（sans-serif），用于后续的文本绘制。
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y =
        height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))

      // 绘制数据点
      this.context_1.beginPath()
      //绘制弧线路径
      this.context_1.arc(x, y, 4, 0, 2 * Math.PI)
      this.context_1.fillStyle = Color.White
      this.context_1.fill()

      // 绘制温度标注
      this.context_1.fillStyle = '#333333'
      this.context_1.fillText(`${temp}°`, x, y - 15)
    })
  }

  drawLineChart2() {
    if (!this.daysWeather.daily || this.daysWeather.daily.length === 0) {
      console.log('No data available for drawing chart')
      return
    }
    //canvas的宽高
    const width = this.context.width
    const height = this.context.height
    const padding: GeneratedObjectLiteralInterface_1 = { top: 30, bottom: 25, left: 15, right: 15 }
    const dataPoints = this.daysWeather.daily!.map(item => Number(item.tempMin))
    const maxTemp = Math.max(...dataPoints)
    const minTemp = Math.min(...dataPoints)

    console.log('TestTag'+maxTemp+minTemp)

    // 清除画布
    this.context.clearRect(0, 0, width, height)

    // 绘制折线
    this.context.beginPath()
    this.context.strokeStyle = Color.White
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
    this.context.font = '55px sans-serif'
    dataPoints.forEach((temp, index) => {
      const x = padding.left + (index * (width - padding.left - padding.right) / (dataPoints.length - 1))
      const y =
        height - padding.bottom - ((temp - minTemp) / (maxTemp - minTemp) * (height - padding.top - padding.bottom))

      // 绘制数据点
      this.context.beginPath()
      //绘制弧线路径
      this.context.arc(x, y, 4, 0, 2 * Math.PI)
      this.context.fillStyle = Color.White
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