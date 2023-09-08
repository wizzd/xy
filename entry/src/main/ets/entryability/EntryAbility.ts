import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
let atManager = abilityAccessCtrl.createAtManager();



export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    globalThis.context = this.context;
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // AppStorage.SetOrCreate('window',windowStage)
    // // 判断是否允许相机请求
    // try {
    //   atManager.requestPermissionsFromUser(this.context,  [
    //     'ohos.permission.CAMERA',
    //
    //   ], (err, data)=>{
    //     console.info("data:" + JSON.stringify(data));
    //     console.info("data permissions:" + data.permissions);
    //     console.info("data authResults:" + data.authResults);
    //   });
    // } catch(err) {
    //   console.log(`catch err->${JSON.stringify(err)}`);
    // }
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
