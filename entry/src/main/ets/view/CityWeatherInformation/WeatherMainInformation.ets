import City from '../../viewMainmodel/City'
import ConditionInformation from '../../viewMainmodel/ConditionInformation'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { CollaborationDevicePicker } from '@hms.collaboration.CollaborationDevicePicker'
import { CommonConstants } from '../../commom/constants/CommonConstants'
import getWarning from '../../viewmodel/getWarning'

@Component
export default struct WeatherMainInformation {
  @Prop weatherMainInformation: City<WeatherInformation>
  @Prop daysWeather: WeatherInformation
  @Prop airCondition: ConditionInformation

  @State isMainInformation:boolean = false
  @State isWarning :boolean = false

  build() {
    if (this.daysWeather.daily && this.airCondition.now != undefined) {
      Column({ space: 20 }) {
        Column({ space: 15 }) {
          Text(`${this.weatherMainInformation.detail?.now?.temp}°`).fontSize(120).fontWeight(600).fontColor(Color.White)
          Text(`${this.daysWeather.daily[0].tempMin}°/${this.daysWeather.daily[0].tempMax}°`)
            .fontSize(18)
            .fontWeight(500)
            .fontColor(Color.White)

          Row({ space: 20 }) {
            Text(`${this.weatherMainInformation.detail?.now?.text}`)
              .fontSize(21)
              .fontWeight(500)
              .fontColor(Color.White)
            Text(`空气${this.airCondition.now.category}`).fontSize(21).fontWeight(500).fontColor(Color.White)
          }
          .justifyContent(FlexAlign.Center)
        }
        .onClick(() => this.isMainInformation = !this.isMainInformation)
        .bindSheet(this.isMainInformation, this.MainInformation(), {
          detents: [700],
          backgroundColor: Color.White,
          blurStyle: BlurStyle.Thick,
          showClose: true,
          enableOutsideInteractive: false, //是否允许用户在 Sheet 以外的区域交互
          dragBar: true
        })


        if (this.airCondition.warning != undefined && this.airCondition.warning[0] != undefined) {
          Row({ space: 10 }) {
            Text(subString(this.airCondition.warning[0].title)).fontSize(18).fontWeight(400).fontColor(Color.White)
            Image($r('app.media.right_arrow')).width(30).fillColor(Color.White)
          }
          .onClick(() => this.isWarning = !this.isWarning)
          .bindSheet(this.isWarning, this.WarningInformation(), {
            detents: [700],
            backgroundColor: Color.White,
            blurStyle: BlurStyle.Thick,
            showClose: true,
            enableOutsideInteractive: false, //是否允许用户在 Sheet 以外的区域交互
            dragBar: true
          })
        }
      }
      .width('100%')
      .margin({
        left: 30,
        right: 30,
        top: 10,
        bottom: 10
      })
      .alignItems(HorizontalAlign.Center)
    }
  }


  //展开主要的天气信息
  @Builder MainInformation() {
    Column({ space: 10 }) {

      Column({ space: 5 }) {
        Text(this.weatherMainInformation.name).fontSize(20).fontWeight(CommonConstants.FONT_WEIGHT_600)
        if (this.weatherMainInformation.detail?.now?.obsTime) {
          Text(this.CalculateTime(this.weatherMainInformation.detail?.now?.obsTime)).fontSize(15).opacity(0.6)
        }
      }
      .width('100%')
      .height(50)
      .alignItems(HorizontalAlign.Start)


      if (this.weatherMainInformation.detail?.now && this.daysWeather.daily && this.airCondition.now != undefined) {
        Row() {
          Column({ space: 25 }) {
            Text(`${this.weatherMainInformation.detail?.now?.temp}°`)
              .fontSize(100)
              .fontWeight(500)

            Row() {
              Text(`${this.weatherMainInformation.detail?.now?.text} °`)
                .fontWeight(300)
                .fontSize(20).fontWeight(200)
              Text(`空气${this.airCondition.now.category}`).fontColor(Color.White).fontSize(10).fontWeight(300)
            }
            .justifyContent(FlexAlign.Center)
          }.layoutWeight(1)

          Image($r(`app.media.${this.weatherMainInformation.detail.now.icon}`)).width(100).height(100)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .margin(50)
      }

      Divider()
        .color('#ff5b5a5a')
        .width('95%')


      Grid() {
        if (this.weatherMainInformation.detail?.now) {
          GridItem() {
            this.RealTimeCard('体感温度', `${this.weatherMainInformation.detail?.now?.feelsLike}°`)
          }

          GridItem() {
            //风向
            this.RealTimeCard(this.weatherMainInformation.detail.now?.windDir,
              `${this.weatherMainInformation.detail?.now?.windScale}级`)
          }

          GridItem() {
            this.RealTimeCard('风向360角度', `${this.weatherMainInformation.detail?.now?.wind360}`)
          }

          GridItem() {
            this.RealTimeCard('相对湿度', `${this.weatherMainInformation.detail?.now?.humidity}%`)
          }

          GridItem() {
            this.RealTimeCard('过去1小时降水量', `${this.weatherMainInformation.detail?.now?.precip}/ml`)
          }

          GridItem() {
            this.RealTimeCard('大气压强', `${this.weatherMainInformation.detail?.now?.pressure}/BP`)
          }

          GridItem() {
            this.RealTimeCard('能见度', `${this.weatherMainInformation.detail?.now?.humidity}/Km`)
          }

          GridItem() {
            this.RealTimeCard('云量', `${this.weatherMainInformation.detail?.now?.cloud}%`)
          }

          GridItem() {
            this.RealTimeCard('露点温度', `${this.weatherMainInformation.detail?.now?.humidity}°`)
          }
        }
      }
      .width('100%')
      .height(300)
      .rowsTemplate('1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr 1fr')
    }
    .width('95%')
    .height('100%')
    .margin({top:20})
    .padding(10)
  }



  //展开主要的预警信息
  @Builder WarningInformation(){

    Column({space:10}) {
      ForEach(this.airCondition.warning,(warn:getWarning)=>{
        List({space:15}) {
          ListItem() {
            Column({space:8}){
              Row({space:8}) {
                Image($r('app.media.warning_picture')).width(20).height(20)
                Text(warn.title).fontSize(16).fontWeight(500)
              }
              Text(formatDate(warn.pubTime)).fontSize(12).fontWeight(500)
              Text(warn.text).fontSize(16)
            }
            .alignItems(HorizontalAlign.Start)
            .padding(10)
            .margin(10)
            .width('95%')
          }
        }
        .width('100%')
      })
    }

  }



  @Builder RealTimeCard(title: string, context:string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(12)
        .opacity(0.8)
      Text(context)
        .fontSize(16)
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
    }
  }


  //计算时间的差值
  CalculateTime( data : string): string {
    // 移除时区偏移，将其转换为一个Date对象
    let obsDate = new Date(data.replace('T', ' ').replace('+08:00', ''));

    // 获取当前时间
    let currentDate = new Date();

    // 计算时间差，单位是毫秒, 将时间差转换为分钟
    let diffInMinutes = Math.floor((currentDate.getTime() - obsDate.getTime()) / (1000 * 60));

    // 根据时间差显示“X分钟前”
    let timeAgo:string = ''
    if (diffInMinutes < 1) {
      timeAgo = "刚刚发布";
    } else {
      timeAgo = diffInMinutes + "分钟前发布";
    }
    return timeAgo
  }
}


//预警信息的修正工作
function subString(title: string): string{
  const regex = /发布(.*?预警)/; // 修改正则表达式
  const match = title.match(regex);

  if (match) {
    const extractedText = match[1];
    return extractedText
    console.log(extractedText); // 输出：大风蓝色预警
  } else {
    console.log("未找到匹配内容");
  }
  return ''
}

//预警获得时间
function formatDate(dateString: string): string {
  const regex = /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})/;
  const match = dateString.match(regex);

  if (match && match.length === 6) {
    const year = parseInt(match[1])
    const month = parseInt(match[2]);
    const day = parseInt(match[3]);
    const hour = parseInt(match[4])
    const minutes = match[5]
    return `${year}-${month}-${day} ${hour}:${minutes}`;
  }

  return dateString;
}