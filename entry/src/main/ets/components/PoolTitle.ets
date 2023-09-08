import router from '@ohos.router';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import { RemoteDeviceModel, BUNDLE_NAME } from '../model/RemoteDeviceModel'
import { DeviceDialog } from '../components/DeviceDialog'
import Logger from '../utils/Logger'

const TAG: string = 'PoolTitle'

const DEVICE_DISCOVERY_RANGE: number = 1000
const REMOTE_ABILITY_STARTED: string = 'remoteAbilityStarted'
import { KvStoreModel } from '../model/KvStoreModel'
// import rpc from '@ohos/r'



@Component
export struct  PoolTitle {
  @State deviceList: Array<deviceManager.DeviceInfo> = []
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  private dialogController: CustomDialogController = null
  @State selectedIndex: number = 0
  private startAbilityCallBack: (key) => void
  private kvStoreModel:KvStoreModel = new KvStoreModel()
  private context

  /*
   * 选择设备
   * */
  onSelectedIndexChange = async (index: number) => {
    this.selectedIndex = index
    if (this.selectedIndex === 0) {
      Logger.info(TAG, `stop ability`)
      this.deviceList = []
      this.dialogController.close()
      return
    }
    this.selectDevice()
  }


  /*
   * 恢复初始状态
   * 关闭分布式设备管理能力
   * */
  clearSelectState(){
    this.deviceList = []
    this.dialogController.close()
    if (this.remoteDeviceModel === undefined) {
      return
    }
    this.remoteDeviceModel.unregisterDeviceListCallback()
  }


  /*
   * 选择设备
   * */
  selectDevice() {
    if (this.remoteDeviceModel === null || this.remoteDeviceModel.discoverList.length <= 0) {
      this.startAbility(this.deviceList[this.selectedIndex].networkId)
      this.clearSelectState()
      return
    }

    this.remoteDeviceModel.authenticateDevice(this.deviceList[this.selectedIndex], () => {
      Logger.info(TAG, `auth and online finished`)
      for (let i = 0; i < this.remoteDeviceModel.deviceList.length; i++) {
        if (this.remoteDeviceModel.deviceList[i].deviceName === this.deviceList[this.selectedIndex].deviceName) {
          this.startAbility(this.remoteDeviceModel.deviceList[i].networkId)
          // this.kvStoreModel.setOnMessageReceivedListener(this.context, REMOTE_ABILITY_STARTED, () => {
          //   Logger.info(TAG, 'OnMessageReceived, terminateSelf')
          // })
          // this.startRemoteExtension(deviceId, params)
        }
      }
    })
    this.clearSelectState()
  }


  startRemoteExtension(deviceId,params) {

  }

  /*
   * 显式拉起Ability，通过bundleName、abilityName和moduleName可以唯一确定一个Ability
   * */
  async startAbility(deviceId) {
    let context = getContext(this) as any
    context.startAbility(
      {
        bundleName: BUNDLE_NAME,
        abilityName: 'EntryAbility',
        deviceId: deviceId,
        parameters: {
          isRemote: 'isRemote'
        }
      }).then((data) => {
      Logger.info(TAG, `start ability finished: ${JSON.stringify(data)}`)
    })
  }

  /*
   * 获取设备列表并显示自定义弹窗
   * */
  showDiainfo(){
    this.deviceList = []
    this.remoteDeviceModel.registerDeviceListCallback(() => {
      Logger.info(TAG, `registerDeviceListCallback, callback entered`)
      // 添加设备信息
      this.deviceList.push({
        deviceId: '0',
        deviceName: getContext(this).resourceManager.getStringSync($r('app.string.localhost').id),
        deviceType: 0,  // 未知设备
        networkId: '',
        range: DEVICE_DISCOVERY_RANGE  // 发现设备的距离
      })
      let deviceTempList = this.remoteDeviceModel.discoverList.length > 0 ? this.remoteDeviceModel.discoverList : this.remoteDeviceModel.deviceList
      for (let i = 0; i < deviceTempList.length; i++) {
        Logger.debug(TAG, `device ${i}/${deviceTempList.length} deviceId= ${deviceTempList[i].deviceId},
        deviceName= ${deviceTempList[i].deviceName}, deviceType= ${deviceTempList[i].deviceType}`)
        this.deviceList.push({
          deviceId: deviceTempList[i].deviceId,
          deviceName: deviceTempList[i].deviceName,
          deviceType: deviceTempList[i].deviceType,
          networkId: deviceTempList[i].networkId,
          range: DEVICE_DISCOVERY_RANGE
        })
      }
    })

    // 初始化设备弹框并显示
    if(this.dialogController === null){
       this.dialogController = new CustomDialogController({
         builder: DeviceDialog({
           deviceList: this.deviceList,
           selectedIndex: this.selectedIndex,
           onSelectedIndexChange: this.onSelectedIndexChange
         }),
         cancel: () => {
           this.clearSelectState()
         },
         autoCancel: true,
         alignment:  DialogAlignment.Center
       })
    }
    this.dialogController.open()
  }

  aboutToAppear(){
    this.context = getContext(this) as any
  }

  build(){
    // 标题栏
    Row(){
      Image($r('app.media.back'))
        .width('25')
        .margin(15)
        .onClick(async () => {
        let context = getContext(this) as any
        context.terminateSelf()
      })
      Text('硬件资源池').fontSize(30).fontColor('#0edff1').fontWeight('bold')
      Image($r('app.media.menu')).width('25').margin(15).onClick(() => {
      }).bindMenu(this.MyMenu)
    }
    .height('10%')
    .width('100%')
    .backgroundColor('#3669a0')
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => {
      this.showDiainfo()
    })
  }

  @Builder
  MyMenu(){
    Menu(){
      MenuItem({ startIcon: $r("app.media.icon"), content: "组网" })
        .onChange(() => {
          // console.log(`哈哈哈哈点击了`)
          // router.pushUrl({url:'pages/Network'})

        })
      MenuItem({ startIcon: $r("app.media.icon"), content: "关于" })
    }
  }
}