
import { PoolItem } from './PoolItem'
import { PoolTitle } from '../pages/PoolTitle'
import { item,itemData } from '../model/PoolData'

@Entry
@Component
struct Index {
  dialogController
  @State isOpen:boolean = true
  itemArr:item[] = itemData

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