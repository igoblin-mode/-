import { HttpUtil } from '../../utils/HttpUtil'
import { UserNameManager } from '../../utils/GlobalState'
import { Shop } from '../../model/Shop'
import { ImageUtil } from '../../utils/ImageUtil';
import { router } from '@kit.ArkUI';

@Observed
class MyShop implements Shop {
  // 定义接口要求的所有属性
  public shopId: number;
  public ownerName: string
  public shopName: string;
  public location: string;
  public description: string;
  public imagePath: string;
  public category: string;
  public openTime: string;
  public closeTime: string;
  public avgRating: number

  // 构造函数，接收初始化数据
  constructor(shopData: Shop) {
    this.shopId = shopData.shopId;
    this.ownerName = shopData.ownerName
    this.shopName = shopData.shopName;
    this.location = shopData.location;
    this.description = shopData.description;
    this.imagePath = shopData.imagePath;
    this.category = shopData.category;
    this.openTime = shopData.openTime;
    this.closeTime = shopData.closeTime;
    this.avgRating = shopData.avgRating;
  }
}

@CustomDialog
@Component
export struct MyShopDialog {

  // 模拟店铺数据
  @State shops: MyShop[] =[]

  async aboutToAppear(): Promise<void> {
    try{
      const fetchedShops = await HttpUtil.getMyShop(UserNameManager.getName())
      this.shops = fetchedShops
      console.log("我的店铺："+this.shops.length)
    }catch (error){
      console.error("获取店铺数据失败:", error);
    }
  }

  controller: CustomDialogController;

  build() {
   Stack(){
     if (this.shops.length === 0) {
       // 无数据状态
       Column() {
         Image($r('app.media.empty_state')) // 空状态图标资源
           .width(100)
           .height(100)
           .opacity(0.5)

         Text("暂无店铺")
           .fontSize(18)
           .fontColor(Color.Gray)
           .margin({ top: 16 })
       }
       .width('100%')
       .height('100%')
       .justifyContent(FlexAlign.Center)
       .alignItems(HorizontalAlign.Center)
     }else{
       Scroll() {
         Column(){
           Text('您的店铺信息如下')
             .fontSize(16)
             .fontColor('#666')
             .margin({ top: 10, bottom: 10 })
           List() {
             ForEach(this.shops, (shop:MyShop) => {
               ShopCard({
                 shop: shop,
                 onShopClick: (id: number) => this.navigateToShopDetail(id)
               })
             })
           }
           .padding(16)
         }
       }
     }
     Image($r('app.media.close'))
       .width(40)
       .height(40)
       .position({ x: '80%', y: '4%' })
       .onClick(() => this.controller.close())
       .zIndex(999)
   }
  }
  // 导航到店铺详情页
  navigateToShopDetail(shopId: number): void{
    // 关闭当前对话框
    this.controller.close();
    // 跳转到店铺详情页，传递shopId参数
    router.pushUrl({
      url: 'pages/Shop/ShopDetail',
      params: {
        shopId: shopId
      }
    });
  }
}

// 店铺卡片组件

@Component
export struct ShopCard {
  @Prop shop: Shop; // 接收父组件传入的店铺数据
  onShopClick?: (id: number) => void; // 添加可选的点击回调函数

  build() {
    Column() {
      // 卡片容器
      Column() {
        // 图片区域
        Image(ImageUtil.getFullImageUrl(this.shop.imagePath))
          .width(100)
          .height(100)
          .borderRadius(8)
          .margin({ bottom: 8 })

        // 文字信息区域
        Column({ space: 4 }) {
          // 店铺名称
          Text('店铺名称：'+this.shop.shopName)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // 店铺地址
          Text('店铺地址：'+this.shop.location)
            .fontSize(14)
            .fontColor(0xFF666666)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          // // 店铺ID（隐藏式显示）
          // Row() {
          //   Text("ID:")
          //     .fontSize(12)
          //     .fontColor(0xFF999999)
          //   Text(this.shop.shopId.toString())
          //     .fontSize(12)
          //     .fontColor(0xFF999999)
          // }
          // .margin({ top: 4 })
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F9F9F9')
      .margin({ bottom: '10'})
      .borderRadius(12)
      .onClick(() => {
        this.onShopClick?.(this.shop.shopId);
      })
      .shadow({
        radius: 4,
        color: 0x1A000000,
        offsetX: 0,
        offsetY: 2
      })
    }
    .width('100%')
  }
}
