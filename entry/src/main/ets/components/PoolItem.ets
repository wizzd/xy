import router from '@ohos.router';
import mediaquery from '@ohos.mediaquery';
let portraitFunc = null;

// @Preview
@Component
export struct PoolItem {
  @State itemWidth:string = '22%'
  @State mLeft:string = '2.4%'
  img:string
  title:string
  type:string
  time:string
  router:string

  // 当设备横屏时条件成立
  listener = mediaquery.matchMediaSync('(orientation: landscape)');

   aboutToAppear() {
    // 绑定当前应用实例
    portraitFunc = this.onPortrait.bind(this);
    // 绑定回调函数
    this.listener.on('change', portraitFunc);
  }

  // 当满足媒体查询条件时，触发回调
  onPortrait(mediaQueryResult) {
    if (mediaQueryResult.matches) { // 若设备为横屏状态，更改相应的页面布局
      this.itemWidth = '22%';
      this.mLeft = '2.4%'
    } else {
      this.itemWidth = '45%';
      this.mLeft = '3.3%'
    }
  }


  build() {
    Column(){
      Row(){
        Image(this.img)
          .width(80)
          .height('80%')
          .margin({left:'5%',top:'10%'})
        Column(){
          Row(){
            Text(this.title)
              .fontSize(15)
              .fontColor('#fff')
          }
          Row(){
            Text(this.type)
              .fontSize(10)
              .fontColor('#fff')
          }.margin({top:'20%'})
          Row(){
            Text(this.time)
              .fontSize(10)
              .fontColor('#fff')
          }.margin({top:'10%'})
        }.width('50%')
        .height('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({left:10,top:'20%'})

      }.width('100%')
      .height('80%')
      Row(){
        Image($r('app.media.edit'))
          .width(20)
          .height(20)
          .margin({right:10})
      }
      .width('100%')
      .height('20%')
      .justifyContent(FlexAlign.End)
    }
    .width(this.itemWidth)
    .height('25%')
    .backgroundColor('#3c475d')
    .margin({left:this.mLeft,top:'3%'})
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      router.pushUrl({url:this.router})
      // router.push()
    })
  }
}