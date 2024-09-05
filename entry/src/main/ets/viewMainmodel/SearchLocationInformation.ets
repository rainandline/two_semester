import { getLocationInformation } from '../viewmodel/getLocationInformation'
import { getReferInformation } from '../viewmodel/getReferInformation'

export default class SearchLocationInformation{
  code?: string
  location?: getLocationInformation[]
  refer?: getReferInformation[]

  constructor(code?: string, location?: getLocationInformation[], refer?: getReferInformation[]) {
    this.code = code
    this.location = location
    this.refer = refer
  }
}
