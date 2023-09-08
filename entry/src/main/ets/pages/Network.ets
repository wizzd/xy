@Entry
@Component

export struct Network {
  build(){
    Column(){
       Row(){
         Text('发现设备')
           .fontSize(30)
           .fontColor('#0edff1')
           .fontWeight('bold')
       }
       .width('100%')
       .height('10%')
       .backgroundColor('#3669a0')
       .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}