import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { Permissions } from '@ohos.abilityAccessCtrl'
import bundleManager from '@ohos.bundle.bundleManager';
import Logger from './Logger';

const TAG: string = '[Permission123]';

// const PERMISSIONS: Array<Permissions> = [
//   'ohos.permission.CAMERA',
// ]

const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.CAMERA',
  // 'ohos.permission.MEDIA_LOCATION',
  // 'ohos.permission.MICROPHONE',
  // 'ohos.permission.READ_MEDIA',
  // 'ohos.permission.WRITE_MEDIA'
];

export default async function grantPermission() {
    try{
      // 获取应用程序的accessTokenID
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
        );
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      let tokenId = appInfo.accessTokenId;
      let atManager = abilityAccessCtrl.createAtManager();
      let pems: Array<Permissions> = [];
      Logger.info(TAG, `${tokenId}`);

      for (let i = 0; i < PERMISSIONS.length; i++) {
        let state = await atManager.checkAccessToken(tokenId, PERMISSIONS[i]);
        Logger.info(TAG, `grantPermission  checkAccessToken ${PERMISSIONS[i]} + : ${JSON.stringify(state)}`);
        if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          pems.push(PERMISSIONS[i]);
        }
      }

      if (pems.length > 0) {
        Logger.info(TAG, 'grantPermission  requestPermissionsFromUser :' + JSON.stringify(pems));
        let result = await atManager.requestPermissionsFromUser(globalThis.context, pems);

        let grantStatus: Array<number> = result.authResults;
        let length: number = grantStatus.length;
        for (let i = 0; i < length; i++) {
          Logger.info(TAG, `grantPermission  requestPermissionsFromUser ${result.permissions[i]} + : ${grantStatus[i]}`);

          if (grantStatus[i] === 0) {
            // 用户授权，可以继续访问目标操作
          } else {
            // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能
            console.log(TAG + 'grantPermission  fail ');
            return false;
          }
        }
      }
      // 授权成功
      Logger.info(TAG, 'grantPermission  success ');
      return true;
    } catch (err) {
      Logger.info(TAG, 'grantPermission  fail ');
      return false;
    }
}