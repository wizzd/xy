import camera from '@ohos.multimedia.camera';
import Logger from '../utils/Logger'
import deviceInfo from '@ohos.deviceInfo';

const TAG = '[CameraModel]';

export default  class CarmerService {
  private videoSourceType: number = 0;
  private cameraMgr: camera.CameraManager = undefined;
  private camerasArray = undefined;
  private cameraInput= undefined;
  // 初始化相机
  async initCamera(surfaceId: string){
    Logger.info(TAG, `initCamera surfaceId:${surfaceId}`);
    Logger.info(TAG, `deviceInfo.deviceType = ${deviceInfo.deviceType}`);
    await this.cameraRelease();
    //deviceInfo.deviceType => default：智能手机  tablet：平板 tv：智慧屏 wearable：智能穿戴 liteWearable：轻量级智能穿戴 smartVision：智慧视觉设备
    if (deviceInfo.deviceType == 'default') {
      // 智能手机
       this.videoSourceType = 1
    } else {
      this.videoSourceType = 0
    }
    // try {
    //   Logger.info(TAG, 'getCameraManager try begin');
    //   this.cameraMgr = camera.getCameraManager(globalThis.cameraContext);
    //   Logger.info(TAG, 'getCameraManager try end');
    // } catch (e) {
    //   Logger.info(TAG, `getCameraManager catch e:${JSON.stringify(e)}`);
    //   Logger.info(TAG, `getCameraManager catch code:${JSON.stringify(e.code)}`);
    //   Logger.info(TAG, `getCameraManager catch message:${JSON.stringify(e.message)}`);
    // }
    this.cameraMgr = camera.getCameraManager(globalThis.context);
    Logger.info(TAG, `getCameraManager ${JSON.stringify(this.cameraMgr)}`);
    this.camerasArray = this.cameraMgr.getSupportedCameras();
    // Logger.info(TAG, `get cameras ${this.camerasArray.length}`);
    if (this.camerasArray.length === 0) {
      Logger.info(TAG, 'cannot get cameras');
      return;
    }

    let mCamera = this.camerasArray[0];
    this.cameraInput = this.cameraMgr.createCameraInput(mCamera);
    this.cameraInput.open();
  }

  /**
   * 资源释放
   */
  async cameraRelease() {
    Logger.info(TAG, 'releaseCamera');
    if (this.cameraInput) {
      await this.cameraInput.close();
    }
  }
}