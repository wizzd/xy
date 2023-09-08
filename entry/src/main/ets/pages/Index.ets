
import { PoolItem } from '../components/PoolItem'
import { PoolTitle } from '../components/PoolTitle'
import { item,itemData } from '../model/PoolData'
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import Logger from '../utils/Logger'
import { KvStoreModel } from '../model/KvStoreModel'
export const BUNDLE_NAME = 'com.example.myapplication'

const TAG: string = 'Index'
@Entry
@Component
struct Index {
  dialogController
  @State isOpen:boolean = true
  @State isDistributed: boolean = false
  itemArr:item[] = itemData
  private kvStoreModel:KvStoreModel = new KvStoreModel()
  private localExtensionRemote = null
  private context
  // onLand = (mediaQueryResult) => {
  //   Logger.debug(TAG, `onLand: mediaQueryResult.matches= ${mediaQueryResult.matches}`)
  //   if (mediaQueryResult. ) {
  //     this.isLand = true
  //   } else {
  //     this.isLand = false
  //   }
  // }

  connectLocalExtension(){
    let localServiceWant = {
      bundleName: BUNDLE_NAME,
      abilityName: 'ServiceAbility',
    }
    let connectOptions = {
      onConnect(elementName, remote) {
        globalThis.viewThis.localExtensionRemote = remote
        Logger.info(TAG, `onConnect called elementName is ${JSON.stringify(elementName)}`)
      },
      onDisconnect(elementName) {
        globalThis.viewThis.context.terminateSelf()
        Logger.info(TAG, `OnDisconnect called elementName is ${JSON.stringify(elementName)}`)
      },
      onFailed(code) {
        globalThis.viewThis.context.terminateSelf()
        Logger.info(TAG, `OnFailed called code is ${JSON.stringify(code)}`)
      }
    }
    this.context.connectServiceExtensionAbility(localServiceWant, connectOptions)
  }

  async aboutToAppear(){
    // 权限请求
    this.context = getContext(this) as any
    let atManager = abilityAccessCtrl.createAtManager()
    let permission: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC','ohos.permission.CAMERA']
    try {
      atManager.requestPermissionsFromUser(this.context, permission ).then((data) => {
        Logger.info(TAG, `data: ${JSON.stringify(data)}`)
      }).catch((err) => {
        Logger.info(TAG, `err: ${JSON.stringify(err)}`)
      })
    } catch(err) {
      Logger.info(TAG, `catch err->${JSON.stringify(err)}`)
    }

    globalThis.viewThis = this
    // this.connectLocalExtension()
  }

  build() {
    Column() {
      // 资源池标题
      PoolTitle()
      // 资源池
      this.PoolList()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#3c475d')
  }

 @Builder PoolList(){
   Row(){
     Flex({ wrap: FlexWrap.Wrap}) {
       ForEach(this.itemArr, (item:item) => {
         PoolItem({
           img: item.img,
           title: item.title,
           type:item.type,
           time: item.time,
           router: item.router
         })
       },(item) => item.id.toString())
     }
     .height('80%')
     .width('90%')
     .backgroundColor('#3669a0')
     .border({
       width:2,
       radius:20,
       color:'#0edff1',
     })
     .shadow({ radius: 10, color: '#0edff1', offsetX: 6, offsetY: 6})
   }.width('100%')
   .height('90%')
   .justifyContent(FlexAlign.Center)
   .alignItems(VerticalAlign.Center)
 }
}