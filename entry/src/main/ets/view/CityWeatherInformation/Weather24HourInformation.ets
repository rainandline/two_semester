import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { getNowdayWeather } from '../../viewmodel/getNowdayWeather'

@Component
export default struct Weather24HourInformation{

  @Prop  hourWeather: WeatherInformation

  build() {
    Row() {

      List({space:30}) {
        ForEach(this.hourWeather.hourly,(data:getNowdayWeather)=>{
          ListItem() {
            Column({space:20}) {
              Text(`${data.fxTime ? extractTime(data.fxTime) : ''}`).fontSize(16).fontColor(Color.Black).fontWeight(400)
              Image($r(`app.media.${data.icon}`)).width(30).height(30).fillColor(Color.Black)
              Text(`${data.temp}°`).fontSize(20).fontWeight(500).fontColor(Color.Black)
            }
          }
        })
      }
      .width('100%')
      .height(145)
      .listDirection(Axis.Horizontal)
      .backgroundColor("#FFDED8D8")
      .borderRadius(10)
      .margin({top:20})
      .padding({left:20,right:20,top:10,bottom:10})
    }
  }
}

//时间格式化
function extractTime(dateTimeString: string): string {
  const regex = /T(\d{2}:\d{2})/;
  const match = dateTimeString.match(regex);
  return match ? match[1] : '';
}