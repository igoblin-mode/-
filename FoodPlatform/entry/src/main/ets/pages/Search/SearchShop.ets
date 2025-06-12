import { Shop } from '../../model/Shop'
import { HttpUtil } from '../../utils/HttpUtil'
import ShopDetail from '../Shop/ShopDetail'
import { router } from '@kit.ArkUI';
import { ImageUtil } from '../../utils/ImageUtil';

@Observed
class ShopClass implements Shop {
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
    this.ownerName = shopData.ownerName;
    this.shopName = shopData.shopName;
    this.location = shopData.location;
    this.description = shopData.description;
    this.imagePath = shopData.imagePath;
    this.category = shopData.category;
    this.openTime = shopData.openTime;
    this.closeTime = shopData.closeTime;
    this.avgRating = shopData.avgRating
  }
}

@Component
struct SearchShop{

  @State shops: Shop[] = []
  @Prop @Watch('onSearchMessage')searchMessage: string;

  onSearchMessage(newVal: string) {
    if (newVal) {
      this.loadSearchShop(); // 搜索词变化时重新加载
    }
  }

  aboutToAppear(): void {
    this.loadSearchShop()
  }

  //加载申请列表
  async loadSearchShop() {
    try{
      this.shops = await HttpUtil.getSearchShop(this.searchMessage);
    }catch (error){
      console.error("获取店铺搜索结果失败:", error);
    }
  }

  build() {
    if(this.shops.length === 0){
      // 无数据状态
      Column() {
        Image($r('app.media.empty_state')) // 空状态图标资源
          .width(100)
          .height(100)
          .opacity(0.5)

        Text("暂无相关搜索店铺")
          .fontSize(18)
          .fontColor(Color.Gray)
          .margin({ top: 16 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }else{
      List() {
        ForEach(this.shops, (item: Shop) => {
          ListItem() {
            ShopCard({
              shop: item
            })
              .margin({ top: 20 })
          }
        }, (item: Shop) => item.shopId.toString())
      }
      .padding(10)
      .scrollBar(BarState.Off)
    }
  }

}

@Component
struct ShopCard {
  @ObjectLink shop: ShopClass;
  @State placeholderImage: Resource = $r('app.media.shop_placeholder'); // 占位图

  build() {
    Column(){
      Row() {
        // 左侧店铺图片
        Column() {
          // 显示店铺图片
          if (this.shop.imagePath) {
            Image(ImageUtil.getFullImageUrl(this.shop.imagePath))
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onError(() => {
                console.error('图片加载失败:', this.shop.imagePath);
              })
          } else {
            Image(this.placeholderImage)
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
          }
        }
        .margin({right:20, top: 14})

        // 中间店铺信息
        Column() {
          // 店铺名和状态行
          Text(`店铺名：${this.shop.shopName}`)
            .fontSize(14)
            .fontColor('#333')
            .margin({ bottom: 8,top: 14 })
            .width('100%')

          Text(`位置：${this.shop.location}`)
            .fontSize(14)
            .fontColor('#666')
            .margin({ bottom: 4 })
            .width('100%')

          Text(`分类：${this.shop.category}`)
            .fontSize(14)
            .fontColor('#666')
            .margin({ bottom: 4 })
            .width('100%')

          Text(`营业时间：${this.shop.openTime} - ${this.shop.closeTime}`)
            .fontSize(14)
            .fontColor('#666')
            .width('100%')
        }
        .width('50%')
      }

      Column() {
        if (this.shop.description) {
          Text(`店铺描述：${this.shop.description}`)
            .fontSize(12)
            .fontColor('#666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }
      .width('100%')
      .margin({ top: 8 })
    }
    .borderRadius('20')
    .backgroundColor('#f1f3f5')
    .padding({
      left: 10,
      right: 10
    })
    .onClick(() => {
      // 点击卡片时跳转到店铺详情页，传递shopId参数
      router.pushUrl({
        url: 'pages/Shop/ShopDetail',
        params: {
          shopId: this.shop.shopId
        }
      });
    })
  }
}

export default SearchShop