

import http from '@ohos.net.http'
import City from '../../viewMainmodel/City'
import SearchLocationInformation from '../../viewMainmodel/SearchLocationInformation';
import WeatherInformation from '../../viewMainmodel/WeatherInformation'



interface CityCodeResponse {
  location : Array<City<WeatherInformation>>;
}

class HttpModel {
  //基础的网络请求路径
  private WeatherBaseURL: string = 'https://devapi.qweather.com/v7/'
  private CityBaseURL: string = 'https://geoapi.qweather.com/v2/city/lookup?'
  private key: string = '5936dc34239542f099986a0bf48280c4'
   //private key:string='f6b4c31d80db485aabdbea8277545500'


  //获取城市的信息,返回一个 City<WeatherItem> 类型的数组
  async GetCityInformation(CityName: string): Promise<City<WeatherInformation>[]> {
    let httpRequest = http.createHttp() //创建唯一一个http的请求对象
    try {
      let Result = await httpRequest.request(
        // 1. 请求的网址
        this.CityBaseURL,
        // 2. 请求的选择
        {
          method: http.RequestMethod.GET, //数据请求的方式，此处直接为得到数据
          extraData: { location: CityName, key: this.key }, //请求的选项
        }
      )
      // 3.处理相应的结果
      if (Result.responseCode === 200) {
        let resultInformation = JSON.parse(Result.result.toString()) as CityCodeResponse
        console.log('城市搜索成功', JSON.stringify(resultInformation))

        //Array.prototype.map 方法,数组中的每个元素都调用一个提供的函数,这段代码中使用当前的元素,创建一个新的City类型
        //将 responseData.location 中的每个元素转换为 City<WeatherItem> 实例，并将这些实例收集到 CityMessage 数组中。
        let CityMessage: City<WeatherInformation>[] =
          resultInformation.location.map(loc => new City<WeatherInformation>(loc.name, loc.id))
        return CityMessage
      } else {
        console.log('城市搜索失败：错误1', JSON.stringify(Result));
        throw new Error(`服务器响应错误：${Result.responseCode}`);
      }
    } catch (error) {
      console.log('城市搜索失败：错误2', JSON.stringify(error));
      if (error instanceof Error) {
        if (error.message.includes("Couldn't resolve host name")) {
          throw new Error('网络连接失败，请检查您的网络设置');
        } else if (error.message.includes("Timeout was reached")) {
          throw new Error('网络请求超时，请检查您的网络连接并重试');
        } else {
          throw new Error('搜索失败：' + error.message);
        }
      } else {
        throw new Error('未知错误发生，请稍后重试');
      }
    } finally {
      httpRequest.destroy();
    }
  }

  //可以返回任意类型的数据，params：一个可选的字符串类型参数，代表额外的请求参数
  GetWeatherInformation<T>(type: string, cityId: string | undefined, time: string, params?: string): Promise<T> {
    return new Promise(async (resolve, reject) => {
      let httpRequest = http.createHttp()
      let resp = httpRequest.request(
        `${this.WeatherBaseURL}/${type}/${time}`,
        {
          method: http.RequestMethod.GET,
          extraData: { type: params, location: cityId, key: this.key }
        }
      )
      await resp.then(resp => {
        if (resp.responseCode === 200) {
          let data: T = JSON.parse(resp.result.toString()) as T
          resolve(data)
        } else {
          console.log('获取信息失败 error:', JSON.stringify(resp))
          reject(`获取${time}天气失败`)
        }
      })
    })
  }

  // GetSearchPositionInformation(SearchKey: string): Promise<SearchLocationInformation> {
  //   return new Promise((resolve, reject) => {
  //     let HttpRequest = http.createHttp()
  //     let result = HttpRequest.request(
  //       this.CityBaseURL, {
  //       method: http.RequestMethod.GET,
  //       extraData: { 'location': `${SearchKey}`, 'key': this.key }
  //     }
  //     )
  //     result.then((res)=>{
  //       if(res.responseCode===200) {
  //         console.log('搜索定理信息成功'+res.result)
  //         let data:SearchLocationInformation = JSON.parse(res.result.toString()) as SearchLocationInformation
  //         resolve(data)
  //       } else {
  //         console.log('搜索定理信息失败'+JSON.stringify(res))
  //         reject('搜索定理信息失败')
  //       }
  //     }) .catch((err:string)=> {
  //       console.log('搜索定理信息失败'+err)
  //       reject('搜索定理信息失败')
  //     })
  //   })
  // }

}

//作为唯一的实例对象进行导出
let httpModel = new HttpModel()
export default httpModel as HttpModel