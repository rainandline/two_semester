import City from '../../viewMainmodel/City'
import SearchLocationInformation from '../../viewMainmodel/SearchLocationInformation'
import WeatherInformation from '../../viewMainmodel/WeatherInformation'
import { promptAction } from '@kit.ArkUI'
import HttpModel from '../../commom/util/HttpModel'
import { getLocationInformation } from '../../viewmodel/getLocationInformation'


@Component
export default struct CityAddSearchHeader {
  @Link searchText: string
  @Link searchResults: City<WeatherInformation>[]
  @StorageLink('isSearch') isSearch: boolean = false
  @State isLoading: boolean = false

  async searchCity(text: string) {
    if (!text.trim()) {
      promptAction.showToast({
        message: '请输入城市的信息',
        duration: 2000
      })
      return;
    }

    this.isLoading = true
    try {
      this.searchResults = await HttpModel.GetCityInformation(text)
      console.log('查找城市信息成功', JSON.stringify(this.searchResults))

      if (this.searchResults.length === 0) {
        promptAction.showToast({
          message: '未搜索出相关城市',
          duration: 2000
        })
      }
    } catch (error) {
      console.error('城市搜索失败:', error);
      let errorMessage = '搜索失败，请稍后重试';
      if (error instanceof Error) {
        errorMessage = error.message;
      }
      promptAction.showDialog({
        title: '搜索错误',
        message: errorMessage,
        buttons: [
          {
            text: '确定',
            color: '#3478f6',
          },
        ],
      });
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Row({ space: 5 }) {
      TextInput({ placeholder: '搜索城市（精确到区/县）' })
        .width('85%')
        .backgroundColor('搜索城市')
        .height(40)
        .borderRadius(20)
        .onChange((value: string) => {
          AppStorage.set('isSearch', true)
          this.searchText = value
        })

      Image($r('app.media.CityAddSearch')).width(25).onClick(() => {
        this.searchCity(this.searchText)
      })
    }
    .padding({ top: 10 })
  }
}