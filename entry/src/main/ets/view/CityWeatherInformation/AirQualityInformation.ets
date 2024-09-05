import ConditionInformation from '../../viewMainmodel/ConditionInformation'

@Component
export default struct AirQualityInformation{

  @Prop airCondition: ConditionInformation

  build() {

    if(this.airCondition.now?.aqi) {
      Row({space:10}) {
        Column({space:10}) {
          Text('污染指数').fontSize(15).fontWeight(500)

          Stack() {

            Progress({value:Number(this.airCondition.now?.aqi),total:100,type:ProgressType.Ring}).color(getAQIColor(Number(this.airCondition.now?.aqi))).width(150).height(150)
              .style({ strokeWidth: 15})

            Column() {
              Text(this.airCondition.now.category).fontSize(15)
              Text(this.airCondition.now.aqi).fontSize(50)
            }
          }
          Text('0~500').fontSize(15).fontWeight(500).opacity(0.8)

        }.layoutWeight(1)

        Column({space:10}) {
          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }

          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }

          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }

          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }

          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }

          Row({space:15}) {
            Text('PM10').fontSize(10).opacity(0.6)
            Text(this.airCondition.now.pm10)
          }
        }
        .padding({top:20,left:10,right:10})
      }
      .backgroundColor("#FFDED8D8")
      .borderRadius(10)
      .margin({top:20})
      .padding({left:20,right:20,top:10,bottom:10})
      .height(300)
      .width('100%')
    }


  }
}

function getAQIColor(aqi: number): string {
  if (aqi >= 0 && aqi <= 50) {
    return '#ff4abe4a'; // 优
  } else if (aqi >= 51 && aqi <= 100) {
    return '#ffe5c773'; // 良
  } else if (aqi >= 101 && aqi <= 150) {
    return '#FFA500'; // 轻度污染
  } else if (aqi >= 151 && aqi <= 200) {
    return '#ffe03636'; // 中度污染
  } else if (aqi >= 201 && aqi <= 300) {
    return '#800080'; // 重度污染
  } else if (aqi >= 301 && aqi <= 500) {
    return '#8B4513'; // 严重污染
  } else {
    return '#000000'; // 默认黑色 (AQI 值超出范围)
  }
}