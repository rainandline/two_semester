

export default class City<Item> {
  name: string
  id?: string
  detail?: Item

  //对于 name 和 id 为必有的类型
  //Item可以为任意的类型，可以用于多种不同的数据类型，而无需为每种可能的 detail 类型创建一个单独的类。

  constructor(name: string, id?: string, detail?: Item) {
    this.name = name
    this.id = id
    this.detail = detail
  }


}