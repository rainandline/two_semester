

export default  class IndexBackgroundUtil {
  static getBackgroundImage(WeatherCondition: string): Resource {
    switch (WeatherCondition.toLowerCase()) { //统一的转化为小写，进行数据的标准化
      case '晴':
        return $r('app.media.background_sunny')
      case '多云':
        return $r('app.media.background_clouds')
      case '阴':
        return $r("app.media.background_overcast")
      case '雨':
      case '小雨':
      case '中雨':
      case '大雨': case '雷阵雨': case '阵雨':
        return $r('app.media.background_rain')
      case '雪':
      case '小雪':
      case '中雪':
      case '大雪':
        return $r('app.media.background_snow')
      default:
        return $r("app.media.background_main_page")
    }
  }
}