

export class getQualityAir{
  pubTime: string
  aqi: string
  level: string
  category: string
  primary:string
  pm10: string
  pm2p5: string
  no2: string
  so2: string
  co: string
  o3: string

  constructor(pubTime: string, aqi: string, level: string, category: string, primary: string, pm10: string,
    pm2p5: string, no2: string, so2: string, co: string, o3: string) {
    this.pubTime = pubTime
    this.aqi = aqi
    this.level = level
    this.category = category
    this.primary = primary
    this.pm10 = pm10
    this.pm2p5 = pm2p5
    this.no2 = no2
    this.so2 = so2
    this.co = co
    this.o3 = o3
  }

}