import distributedKVStore from '@ohos.data.distributedKVStore';
import Logger from '../utils/Logger'
const STORE_ID: string = 'myapplication_kvstore'
const TAG:string = 'KvStoreModel'

export class KvStoreModel {
  private kvManager: distributedKVStore.KVManager
  private kvStore

  // 创建并获取KVStore数据库
  async createKvStore(context, callback) {
    if (typeof (this.kvStore) === 'undefined') {
      let config = {
        bundleName: 'ohos.samples.etsdistributedmusicplayer',
        // userInfo: {
        //   userId: '0',
        //   userType: 0
        // },
        context: context
      }
      Logger.info(TAG, 'createKVManager begin')
      this.kvManager = await distributedKVStore.createKVManager(config)
      Logger.info(TAG, `createKVManager success, kvManager`)
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        schema: null,
        securityLevel: 3,
      }
      Logger.info(TAG, 'kvManager.getKVStore begin')
      this.kvStore = await this.kvManager.getKVStore(STORE_ID, options)
      Logger.info(TAG, `getKVStore success`)
      callback()
      Logger.info(TAG, 'kvManager.getKVStore end')
      Logger.info(TAG, 'createKVManager end')
    } else {
      callback()
    }
  }

  async put(key, value) {
    Logger.info(TAG, `kvStore.put ${key} = ${value}`)
    await this.kvStore.put(key, value)
    this.kvStore.get(key).then((data) => {
      Logger.info(TAG, `kvStore.get ${key} = ${JSON.stringify(data)}`)
    })
    Logger.info(TAG, `kvStore.put ${key} finished`)
  }

  setOnMessageReceivedListener(context, msg, callback) {
    Logger.info(TAG, `setOnMessageReceivedListener ${msg}`)
    this.createKvStore(context, () => {
      Logger.info(TAG, 'kvStore.on(dataChange) begin')
      this.kvStore.on('dataChange', 1, (data) => {
        Logger.info(TAG, `dataChange, ${JSON.stringify(data)}`)
        Logger.info(TAG, `dataChange insert ${data.insertEntries.length} udpate ${data.updateEntries.length}`)
        for (let i = 0; i < data.insertEntries.length; i++) {
          if (data.insertEntries[i].key === msg) {
            Logger.info(TAG, `insertEntries receive ${msg} ${JSON.stringify(data.insertEntries[i].value)}`)
            callback()
            return
          }
        }
        for (let i = 0; i < data.updateEntries.length; i++) {
          if (data.updateEntries[i].key === msg) {
            Logger.info(TAG, `updateEntries receive ${msg} ${JSON.stringify(data.updateEntries[i].value)}`)
            callback()
            return
          }
        }
      })
      Logger.info(TAG, 'kvStore.on(dataChange) end')
    })
  }
}