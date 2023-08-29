@Entry
@Component
struct  Ser {
  @State thumb:string = '0'

  build(){
        Column(){
           Row(){
              Text('风力感应试试检测').fontSize(50)
           }
          Row(){
            Text('风力: ')
              .fontSize(35)
              .fontWeight(FontWeight.Bold)
            Text(this.thumb)
              .fontSize(30)
            Text('℃')
              .fontSize(30)
          }.margin(30)

          Button(){
              Text('获取数据')
          }.type(ButtonType.Normal)
          .width(100)
          .height(50)
          .onClick(() => {
            console.info('1313131312')
          })
        }
        .width(('100%'))
        .height('100%')
        .justifyContent(FlexAlign.Center)
  }

  onPageShow(){
    console.log('页面显示了')
    // this.getData()
  }
  onPageHide() {
    // sensor.off(sensor.SensorId.ACCELEROMETER);
  }

  getData() {
    // try {
    //   sensor.on(sensor.SensorId.ACCELEROMETER,  (data) => {
    //     this.thumb = data.x.toString()
    //     console.info('X-coordinate component: ' + data.x);
    //     console.info('Y-coordinate component: ' + data.y);
    //     console.info('Z-coordinate component: ' + data.z);
    //   }, { interval: 10000000 });
    // } catch (err) {
    //   console.error('On fail, errCode: ' + err.code + ' ,msg: ' + err.message);
    // }
  }
}