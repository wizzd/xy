// import camera from '@ohos.multimedia.camera';
// // import media from '@ohos.multimedia.media'
//
//
// @Entry
// @Component
// struct PreviewArea {
//   private mXComponentController: XComponentController = new XComponentController()
//   private surfaceId: string = '-1'
//   private cameraManager: camera.CameraManager = undefined
//   private context: any = getContext(this)
//
//   async initCamera(){
//     // this.cameraManager = await camera.getCameraManager(this.context)
//     // // console.log(`cameraManager,${this.cameraManager}`)
//     // let cameraArray = await this.cameraManager.getSupportedCameras();
//     // console.log(`cameraArray,${cameraArray}`)
//     // console.log(`cameraArray.length,${cameraArray.length}`)
//     // if (cameraArray.length <= 0) {
//     //   console.log('12312312312321213213213')
//     //   // console.error("cameraManager.getSupportedCameras error");
//     //   return;
//     // }
//
//     // if (!this.cameraManager) {
//     //     console.error("camera.getCameraManager error")
//     //     return;
//     //   }
//   }
//   build() {
//
//     Row() {
//       XComponent({
//         id: 'xcomponent',
//         type: 'surface',
//         controller: this.xcomponentController
//       })
//         .onLoad(() => {
//           this.xcomponentController.setXComponentSurfaceSize({surfaceWidth:1920,surfaceHeight:1080});
//           this.surfaceId = this.xcomponentController.getXComponentSurfaceId()
//           this.initCamera()
//         })
//         .width('640px')
//         .height('480px')
//     }
//     .backgroundColor(Color.Black)
//     .position({x: 0, y: 48})
//   }
// }

import grantPermission from '../utils/PermissionUtils';
import Logger from '../utils/Logger'
import CameraModel from '../model/CameraModel'

const TAG: string = '[CameraPage]';

@Entry
@Component
struct  CameraPage {
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId: string = '-1'
  private cameraModel = new CameraModel()
  async aboutToAppear(){
    try{
      const isGrantPermission =  await grantPermission()
      if(isGrantPermission){
        Logger.info(TAG, `权限申请成功  ${isGrantPermission}`);
        if(this.surfaceId){
          this.cameraModel.initCamera(this.surfaceId);
        }
        this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
        Logger.info(TAG, `aboutToAppear,surfaceId=${this.surfaceId}`);
      }
    } catch (err) {
      Logger.info(TAG, `权限申请失败  ${JSON.stringify(err)}`);
    }



  }
  build() {
      Text('相机').fontSize(50).onClick(() => {
        console.log('12312312')
      })
  }
}


