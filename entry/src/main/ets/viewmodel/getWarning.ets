

export default class getWarning{
  id:string
  sender:string
  pubTime:string
  title:string
  startTime:string
  endTime:string
  status:string
  level:string
  severity:string
  severityColor:string
  type:string
  typeName:string
  urgency:string
  certainty:string
  text:string
  related:string

  constructor(id: string, sender: string, pubTime: string, title: string, startTime: string, endTime: string,
    status: string, level: string, severity: string, severityColor: string, type: string, typeName: string,
    urgency: string, certainty: string, text: string, related: string) {
    this.id = id
    this.sender = sender
    this.pubTime = pubTime
    this.title = title
    this.startTime = startTime
    this.endTime = endTime
    this.status = status
    this.level = level
    this.severity = severity
    this.severityColor = severityColor
    this.type = type
    this.typeName = typeName
    this.urgency = urgency
    this.certainty = certainty
    this.text = text
    this.related = related
  }
}