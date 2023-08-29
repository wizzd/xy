@Component
export struct  PoolTitle {
  @Builder
  MyMenu(){
    Menu(){
      MenuItem({ startIcon: $r("app.media.icon"), content: "组网" })
      MenuItem({ startIcon: $r("app.media.icon"), content: "关于" })
    }
  }

  build(){
    // 标题栏
    Row(){
      Image($r('app.media.back')).width('25').margin(15).onClick(async () => {
        // await this.existApp()
      })
      Text('硬件资源池').fontSize(30).fontColor('#0edff1').fontWeight('bold')
      Image($r('app.media.menu')).width('25').margin(15).onClick(() => {
      }).bindMenu(this.MyMenu)
    }
    .height('10%')
    .width('100%')
    .backgroundColor('#3669a0')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}