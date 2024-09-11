import ConditionInformation from '../../viewMainmodel/ConditionInformation'

@Component
export default struct AirQualityInformation {
  @Prop airCondition: ConditionInformation

  build() {

    if (this.airCondition.now?.aqi) {
      Row({ space: 7 }) {
        Column({ space: 17 }) {
          Text('污染指数').fontSize(20).fontWeight(500).fontColor(Color.White)

          Stack() {
            Gauge({ value: Number(this.airCondition.now?.aqi), min: 0, max: 500 })
              .startAngle(210)
              .endAngle(150)
              .colors([
                [ '#00FF00', 0 ],
                [ '#FFFF00', 0.2 ],
                [ '#FFA500', 0.4 ],
                [ '#FF0000', 0.6 ],
                [ '#800080', 0.8 ],
                [ '#8B4513',  1 ]
              ])
              .strokeWidth(20)
              .width(200)
              .height(200)

            Column({ space: 10 }) {
              Text(this.airCondition.now.category).fontSize(20).fontColor(Color.White).opacity(0.8)
              Text(this.airCondition.now.aqi).fontSize(50).fontColor(Color.White).opacity(0.8)
            }

          }.layoutWeight(1)

        }

        Column({ space: 10 }) {
          Row({ space: 22 }) {
            Text('PM10').fontSize(15).opacity(0.6)
            Text(this.airCondition.now.pm10).fontSize(15).fontColor(Color.White)
          }

          Row({ space: 20 }) {
            Text('PM2.5').fontSize(15).opacity(0.6)
            Text(this.airCondition.now.pm2p5).fontSize(15).fontColor(Color.White)
          }

          Row({ space: 30 }) {
            Row() {
              Text('NO').fontSize(15).opacity(0.6)
              Text('2').fontSize(10).opacity(0.6)
            }
            Text(this.airCondition.now.no2).fontSize(15).fontColor(Color.White)
          }

          Row({ space: 32 }) {
            Row() {
              Text('SO').fontSize(15).opacity(0.6)
              Text('2').fontSize(10).opacity(0.6)
            }
            Text(this.airCondition.now.so2).fontSize(15).fontColor(Color.White)
          }

          Row({ space: 35 }) {
            Text('CO').fontSize(15).opacity(0.6)
            Text(this.airCondition.now.co).fontSize(15).fontColor(Color.White)
          }

          Row({ space: 35 }) {
            Row() {
              Text('O').fontSize(15).opacity(0.6)
              Text('3').fontSize(10).opacity(0.6)
            }
            Text(this.airCondition.now.o3).fontSize(15).fontColor(Color.White)
          }
        }
        .padding({ top: 20, left: 10, right: 10 })
         .alignItems(HorizontalAlign.Start)

      }
      .backgroundColor("#2a000000")
      .backgroundBlurStyle(BlurStyle.Thin)
      .borderRadius(10)
      .margin({ top: 20 })
      .padding({ left: 20, right: 20, top: 10, bottom: 10 })
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