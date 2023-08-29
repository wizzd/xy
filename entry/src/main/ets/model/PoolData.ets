export interface item {
  id:number,
  img:string,
  title:string
  type:string
  time:string,
  router:string
}

export const itemData:item[] = [
  {
    id:1,
    img:'/common/images/interfere.jpg',
    title:'侦察飞行器',
    type:'功能分类',
    time:'1970101',
    router:'pages/Ser'
  },
  {
    id:2,
    img:'/common/images/investigate.jpg',
    title:'干扰飞行器',
    type:'功能分类',
    time:'1970101',
    router:'pages/Carme'
  }
]
