import sensor from '@ohos.sensor';
import deviceInfo from '@ohos.deviceInfo'
@Entry
@Component
struct Index {
  @State message: string = 'Hello '


  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold).onClick(()=>{
          sensor.on(sensor.SensorType.SENSOR_TYPE_ID_AMBIENT_TEMPERATURE,function(data){
            console.info('Temperature: ' + data.temperature);
          },
            {interval: 10000000}
          );
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}