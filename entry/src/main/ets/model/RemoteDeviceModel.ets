import deviceManager from '@ohos.distributedHardware.deviceManager';
import Logger from '../utils/Logger'

const TAG: string = 'RemoteDeviceModel'
export const BUNDLE_NAME = 'com.example.myapplication'
let SUBSCRIBE_ID = 100

export class RemoteDeviceModel {
  public deviceList: Array<deviceManager.DeviceInfo> = []
  public discoverList: Array<deviceManager.DeviceInfo> = []
  private deviceManager:deviceManager.DeviceManager = undefined
  private callback: () => void = null
  private authCallback: () => void = null
  registerDeviceListCallback(callback){
    if(typeof (this.deviceManager) !== 'undefined'){
      this.registerDeviceListCallbackImplement(callback)
      return
    }

    try{
      // 创建一个设备管理器实例
      deviceManager.createDeviceManager(BUNDLE_NAME, (err,value) => {
        if (err) {
          Logger.error(TAG, `createDeviceManager failed.${err}`)
          return
        }
        this.deviceManager = value
        this.registerDeviceListCallbackImplement(callback)
      })
    }catch (err){
      Logger.error(TAG, `createDeviceManager throw code:${err.code} message:${err.message}`)
    }
  }

  // 将自身设备示例添加到匹配列表中
  changeStateOnline(device){
     this.deviceList[this.deviceList.length] = device
     Logger.debug(TAG, `online, device list= ${JSON.stringify(this.deviceList)}`)
     this.callback()
    if (this.authCallback !== null) {
      this.authCallback()
      this.authCallback = null
    }
  }


  stateChange(device,state){
     if(state == deviceManager.DeviceStateChangeAction.READY){
       let list = new Array()
       // 已经完成匹配不需要重新显示在匹配列表中
       for (let i = 0; i < this.deviceList.length; i++) {
         if(this.deviceList[i].deviceId !== device.deviceId){
           list[i] = device
         }
       }
       this.deviceList = list
       this.callback()
     } else {
       // 将新的设备信息进行替换
       for (let j = 0; j < this.deviceList.length; j++) {
         if(this.deviceList[j].deviceId === device.deviceId){
           this.deviceList[j] = device
           break
         }
       }
       this.callback()
     }
  }

  registerDeviceListCallbackImplement(callback){
    Logger.info(TAG, 'registerDeviceListCallback')
    this.callback = callback
    if(this.deviceManager === undefined){
      this.callback()
      return
    }

    // 获取所有可信设备列表
    try{
      let list =  this.deviceManager.getTrustedDeviceListSync()
      Logger.info(TAG, `list123`,`${list.length}`)
      if(typeof (list) !== 'undefined' && typeof (list.length) !== 'undefined'){
        this.deviceList = list
      }
    }catch (err) {
      Logger.error(TAG, `getTrustedDeviceListSync throw code:${err.code} message:${err.message}`)
    }
    this.callback()
    // 注册设备状态回调  指示要注册的设备状态回调，返回设备状态和设备信息
    try {
      this.deviceManager.on('deviceStateChange', data => {
          if(data == null){
            return
          }
        switch (data.action) {
          case deviceManager.DeviceStateChangeAction.ONLINE:  // 设备物理上线状态
          this.changeStateOnline(data.device)
            break;
          case  deviceManager.DeviceStateChangeAction.READY: // 设备可用状态，表示设备间信息已在分布式数据中同步完成, 可以运行分布式业务
            this.stateChange(data.device,deviceManager.DeviceStateChangeAction.READY)
            break;
          case  deviceManager.DeviceStateChangeAction.CHANGE:  // 设备信息更改
            this.stateChange(data.device,deviceManager.DeviceStateChangeAction.CHANGE)
            break;
          default:
            break;
        }
      })
      // 查询设备
      this.deviceManager.on('deviceFound', (data) => {
        if (data === null) {
          return
        }
        this.deviceFound(data)
      })
      this.deviceManager.on('discoverFail', (data) => {
        Logger.info(TAG, `discoverFail data= ${JSON.stringify(data)}`)
      })
      this.deviceManager.on('serviceDie', () => {
        Logger.error(TAG, 'serviceDie')
      })
    } catch (err){
      Logger.error(TAG, `on throw code:${err.code} message:${err.message}`)
    }
    // 搜索设备
    this.startDeviceDiscovery()
  }

  deviceFound(data){
    for (let i = 0;i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId === data.device.deviceId) {
        return
      }
    }
    this.discoverList[this.discoverList.length] = data.device
    this.callback()
  }

  // 通过SUBSCRIBE_ID搜索分布式组网内的设备
  startDeviceDiscovery(){
    // 生成发现标识，随机数确保每次调用发现接口的标识不一致
    SUBSCRIBE_ID = Math.floor(65536 * Math.random())
    let info = {
      subscribeId: SUBSCRIBE_ID,
      mode: 0xAA, // 主动模式
      medium: 2, // 自动发现类型，同时支持多种发现类型
      freq: 2,  // 高频率
      isSameAccount: false,
      isWakeRemote: true,
      capability: 0
    }
    Logger.info(TAG, `startDeviceDiscovery${SUBSCRIBE_ID}`)
    try {
      this.deviceManager.startDeviceDiscovery(info)
    } catch (error) {
      Logger.error(TAG, `startDeviceDiscovery throw code:${error.code} message:${error.message}`)
    }
  }

  /*
   * 关闭分布式设备管理能力
   * */
  unregisterDeviceListCallback() {
    try {
      Logger.info(TAG, `stopDeviceDiscovery${SUBSCRIBE_ID}`)
      this.deviceManager.stopDeviceDiscovery(SUBSCRIBE_ID);
    } catch (error) {
      Logger.error(TAG, `stopDeviceDiscovery throw code:${JSON.stringify(error.code)} message:${error.message}`)
    }
    try {
      this.deviceManager.off('deviceStateChange')
      this.deviceManager.off('deviceFound')
      this.deviceManager.off('discoverFail')
      this.deviceManager.off('serviceDie')
    } catch (error) {
      Logger.error(TAG, `off throw code:${error.code} message:${error.message}`)
    }
    this.deviceList = []
    this.discoverList = []
  }

  /*
   * 设备认证匹配
   * */
  authenticateDevice(device, callBack) {
    Logger.info(TAG, `authenticateDevice ${JSON.stringify(device)}`)
    for (let i = 0; i < this.discoverList.length; i++) {
      if (this.discoverList[i].deviceId !== device.deviceId) {
        continue
      }
      let extraInfo = {
        'targetPkgName': BUNDLE_NAME,
        'appName': 'application',
        'appDescription': 'application',
        'business': '0'
      }
      let authParam = {
        'authType': 1,
        'appIcon': '',
        'appThumbnail': '',
        'extraInfo': extraInfo
      }
      try {
        this.deviceManager.authenticateDevice(device, authParam, (err, data) => {
          if (err) {
            this.authCallback = null
            return
          }
          this.authCallback = callBack
        })
      } catch (error) {
        Logger.error(TAG, `authenticateDevice throw throw code:${error.code} message:${error.message}`)
      }
    }
  }
}