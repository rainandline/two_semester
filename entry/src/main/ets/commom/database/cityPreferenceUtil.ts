
import { preferences } from '@kit.ArkData'


class City{
  name:string
  id?: string

  constructor(name:string,id?:string) {
    this.name = name
    this.id = id
  }
}

class CityPreferenceUtil{

  //避免有多个Preference实例引起的覆盖问题，string设置键值
  preferenceMap: Map<string, preferences.Preferences> = new Map()

  // 加载preferences
  async loadPreferences(context, name: string) {
    try {
      //去加载该名下的preference对象
      let preference = await preferences.getPreferences(context, name)

      //你可以在后续的代码中通过键 name 来访问对应的偏好设置对象
      this.preferenceMap.set(name, preference)
      console.log('testTag', `加载Preferences[${name}]成功`)
    } catch (e) {
      //加载失败打印相应的失败信息
      console.log('testTag', `加载Preferences[${name}]失败`, JSON.stringify(e))
    }
  }

  //添加preference
  async putCity(name: string, CityName: string, CityID: string) {

    //判断里面是否存有数据
    if (!this.preferenceMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化！`)
      return
    }

    try {
      //得到相应的preference
      let preference=this.preferenceMap.get(name)
      //写入数据
      await preference?.put(CityName,CityID)
      //刷盘,存储到用户首选项的持久化文件中
      await preference?.flush()
      console.log('testTag', `保存城市[${name}.${CityName} = ${CityID}]成功`)
    } catch (e) {
      console.log('testTag', `保存城市[${name}.${CityName} = ${CityID}]失败`, JSON.stringify(e))
    }
  }

  //根据城市返回存储的id
  async getCity(name: string, CityName: string, CityID: string): Promise<string|null>{
    if (!this.preferenceMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化！`)
      return null
    }
    try {
      let pref = this.preferenceMap.get(name)
      // 读数据
      const cityId = await pref?.get(CityName,null)
      if(cityId){
        console.log('testTag', `读取Preferences[${name}.${CityName} = ${cityId}]成功`)
        return cityId as string
      }
      return null
    } catch (e) {
      console.log('testTag', `读取Preferences[${name}.${CityName} ]失败`, JSON.stringify(e))
      return null
    }
  }

  async getAllCities(name: string): Promise<City[]> {
    if (!this.preferenceMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化`)
      return []
    }
    try {
      let pref = this.preferenceMap.get(name)
      const allEntries = await pref?.getAll()
      if (allEntries) {
        const cityMap = new Map<string, string>(Object.entries(allEntries))
        const cities:City[] = Object.entries(allEntries).map(([key,value]) => new City(key, value))
        console.log('testTag', `读取所有城市成功，共${cityMap.size}个城市`)
        return cities
      }
      return []
    } catch (e) {
      console.log('testTag', `读取所有城市失败`, JSON.stringify(e))
      return []
    }
  }

  async removeCity(name: string,cityName: string) {
    if (!this.preferenceMap.has(name)) {
      console.log('testTag', `Preferences[${name}]尚未初始化！`)
      return
    }
    try {
      let pref = this.preferenceMap.get(name)
      if (pref) {
        await pref.delete(cityName)
        await pref.flush()
      }
      console.log('testTag', `删除城市[${cityName}]成功`)
    } catch (e) {
      console.log('testTag', `删除城市[${cityName}]失败`, JSON.stringify(e))
    }
  }
}

const cityPreferenceUtil= new CityPreferenceUtil()
export default cityPreferenceUtil as CityPreferenceUtil
