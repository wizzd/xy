import grantPermission from '../utils/PermissionUtils';
import Logger from '../utils/Logger'
const TAG: string = '[CameraPage]';
import camera from '@ohos.multimedia.camera';

@Entry
@Component
struct  CameraPage {
  private xcomponentController: XComponentController = new XComponentController()
  private surfaceId: string = ''
  private cameraManager: camera.CameraManager;
  private cameras: any = undefined;
  private cameraOutputCapability: camera.CameraOutputCapability = undefined;
  private cameraIndex: number = 0;
  private cameraInput: camera.CameraInput;
  private previewProfiles: any = undefined;
  private videoResolution: object = { 'frameWidth': 1280, 'frameHeight': 720};
  private previewOutput: camera.PreviewOutput;
  private captureSession: camera.CaptureSession;

  async failureCallback(error): Promise<void> {
    Logger.info(TAG, 'case failureCallback called,errMessage is ' + error.message);
  }

  async catchCallback(error): Promise<void> {
    Logger.info(TAG, 'case catchCallback called,errMessage is ' + error.message);
  }
  async onPageShow() {
    // const isGrantPermission =  await grantPermission()
    // if(isGrantPermission){
    //   Logger.info(TAG, `权限申请成功  ${isGrantPermission}`);
    //   // Logger.info(TAG, `aboutToAppear,surfaceId=${this.surfaceId}`);
    // }
    this.enterInit();
  }

  async enterInit(){
     await this.initCamera(); // 获取设备信息
     await this.createCameraInput(); // 打开相机
     await this.createPreviewOutput(); // 预览流
     await this.createCaptureSession()  // 创建会话
     await this.startCaptureSession()  // 开启会话
  }

  async initCamera(){
      if(this.cameraManager){
        return
      }
    // 获取cameraManager对象
    this.cameraManager = camera.getCameraManager(globalThis.context)
    if (this.cameraManager) {
      Logger.info(TAG, '[camera] case getCameraManager success');
    } else {
      Logger.info(TAG, '[camera] case getCameraManager failed');
      return;
    }
    // 获取当前设备支持的相机列表
    this.cameras = this.cameraManager.getSupportedCameras()

    if (this.cameras) {
      Logger.info(TAG, '[camera] case getCameras success');
    } else {
      Logger.info(TAG, '[camera] case getCameras failed');
    }
    // 获取相机设备支持的输出流能力
    Logger.info(TAG, `this.cameras[this.cameraIndex] ${this.cameras[this.cameraIndex]}`)
    // this.cameraOutputCapability = this.cameraManager.getSupportedOutputCapability(this.cameras[this.cameraIndex]);
    console.log('this.cameras',this.cameras)
    Logger.info(TAG,`this.cameraOutputCapability222222 ${this.cameraOutputCapability}`)
    if (!this.cameraOutputCapability) {
      return;
    }
    // this.videoProfiles = this.cameraOutputCapability.videoProfiles;
  }

   // 创建相机输入
  async createCameraInput(){
    // 创建相机输入流
    this.cameraInput = this.cameraManager.createCameraInput(this.cameras[this.cameraIndex])
    Logger.info(TAG,`this.cameraInput ${this.cameraInput}`)
    if (this.cameraInput) {
      Logger.info(TAG, '[camera] case createCameraInput success');
    } else {
      Logger.info(TAG, '[camera] case createCameraInput failed');
      return;
    }
    await this.cameraInput.open().then(() => {
      Logger.info(TAG, '[camera] case cameraInput.open() called');
    }, this.failureCallback).catch(this.catchCallback);
  }

  // 预览流
  async createPreviewOutput(){
    Logger.info(TAG,'创建预览流进入')
    // Logger.info(TAG, 'createPreviewOutput called');
    // 获取当前设备支持的预览能力
    console.log(TAG,`this.cameraOutputCapability  ${this.cameraOutputCapability}`)
    this.previewProfiles = this.cameraOutputCapability.previewProfiles;
    console.log(TAG,`this.cameraOutputCapability2222222222`)
    this.previewProfiles[0].size.height = this.videoResolution['frameHeight'];
    this.previewProfiles[0].size.width = this.videoResolution['frameWidth'];
    // 创建预览输出流
    this.previewOutput = this.cameraManager.createPreviewOutput(this.previewProfiles[0],this.surfaceId)
    if (!this.previewOutput) {
      Logger.info(TAG, 'create previewOutput failed!');
    }
    // Logger.info(TAG, 'createPreviewOutput done');
    Logger.info(TAG,'创建预览流成功')
  }

  // 创建会话
  async createCaptureSession(){
    Logger.info(TAG, 'createCaptureSession called');
    this.captureSession = this.cameraManager.createCaptureSession()
    Logger.info(TAG,`this.captureSession  ${this.captureSession}`)
    if (!this.captureSession) {
      Logger.info(TAG, 'createCaptureSession failed!');
      return
    }
    this.captureSession.beginConfig();
    this.captureSession.addInput(this.cameraInput);
    this.captureSession.addOutput(this.previewOutput);
    await this.captureSession.commitConfig().then(() => {
      Logger.info(TAG, 'case commitConfig success');
    }, this.failureCallback).catch(this.catchCallback);
  }

  // 开启会话
  async startCaptureSession(){
    if (!this.captureSession) {
      Logger.info(TAG, 'CaptureSession does not exists!');
      return
    }
    await this.captureSession.start().then(() => {
      Logger.info(TAG, 'case start captureSession success');
    }, this.failureCallback).catch(this.catchCallback);
  }
  build() {
    Flex() {
      // 创建XComponent
      XComponent({
        id: 'xcomponent1',
        type: 'surface',
        libraryname: '',
        controller: this.xcomponentController
      })
        .onLoad(() => {
          // 设置Surface宽高（1920*1080），预览尺寸设置参考前面 previewProfilesArray 获取的当前设备所支持的预览分辨率大小去设置
          this.xcomponentController.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 });
          // 获取Surface ID
          this.surfaceId = this.xcomponentController.getXComponentSurfaceId();
          this.enterInit()
        })
        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}



