import deviceManager from '@ohos.distributedHardware.deviceManager';
import Logger from '../utils/Logger'
const TAG = 'DeviceDialog'

@CustomDialog
export struct DeviceDialog {
  controller: CustomDialogController
  private deviceList: Array<deviceManager.DeviceInfo> = []
  private selectedIndex: number = 0
  private onSelectedIndexChange: (selectedIndex) => void
  build(){
     Column(){
       Text('选择设备')
         .fontSize(30)
         .width('100%')
         .fontColor(Color.Black)
         .textAlign(TextAlign.Start)
         .fontWeight(FontWeight.Bold)
       List() {
         ForEach(this.deviceList, (item, index) => {
           ListItem() {
             Row() {
               Text(item.deviceName)
                 .fontSize(21)
                 .width('90%')
                 .fontColor(Color.Black)
               Image(index === this.selectedIndex ? $r('app.media.checked') : $r('app.media.uncheck'))
                 .width('8%')
                 .objectFit(ImageFit.Contain)
             }
             .height(55)
             .margin({ top: 17 })
             .onClick(() => {
               Logger.debug(TAG, `select device: ${item.deviceId}`)
               Logger.debug(TAG, `deviceList: ${JSON.stringify(this.deviceList)}`)
               if (index === this.selectedIndex) {
                 // Logger.info(TAG, `index:${JSON.stringify(index)} ty:${JSON.stringify(typeof (index))} this.selectedIndex:${JSON.stringify(this.selectedIndex)} ${JSON.stringify(typeof (this.selectedIndex))}`)
                 return
               }
               this.selectedIndex = index
               this.onSelectedIndexChange(this.selectedIndex)
             })
           }
         }, item => item.deviceName)
       }
       .width('100%')
       .layoutWeight(1)
       Button() {
         Text('取消')
           .width('90%')
           .fontSize(21)
           .fontColor('#0D9FFB')
           .textAlign(TextAlign.Center)
       }
       .margin({ top: 22 })
       .type(ButtonType.Capsule)
       .backgroundColor(Color.White)
       .onClick(() => {
         this.controller.close()
       })
     }.height(290)
  }
}