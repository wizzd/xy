import window from '@ohos.window';
import common from '@ohos.app.ability.common';
// 获取UIAbility实例的上下文信息
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct  WindowExample {
  @StorageLink('window') storWindow:window.WindowStage = null
  private windowStage = this.storWindow
  // 1.获取应用主窗口。
  private windowClass = null;


  showWindow(){
        this.windowStage.getMainWindow((err, data) => {
           console.log(`'data123456789',${data}`)
          if (err.code) {
            console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
            return;
          }
          this.windowClass = data;
          console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));
          // 2.设置主窗口属性。以设置"是否可触"属性为例。
          let isTouchable = true;
          this.windowClass.setWindowTouchable(isTouchable, (err) => {
            if (err.code) {
              console.error('Failed to set the window to be touchable. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in setting the window to be touchable.');
          })

          let isLayoutFullScreen= false;
          try {
            this.windowClass.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
              if (err.code) {
                console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
                return;
              }
              console.info('Succeeded in setting the window layout to full-screen mode.');
            });
          } catch (exception) {
            console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(exception));
          }
        })
      // 3.为主窗口加载对应的目标页面。
      this.windowStage.loadContent("pages/Carme", (err) => {
        if (err.code) {
          console.error('Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in loading the content.');
      });
    }
  build(){
    Column(){

      Button() {
        Text('Next')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      }).onClick(() => {
        // this.showWindow()
        console.log('312312')
      })
    }
  }
}
