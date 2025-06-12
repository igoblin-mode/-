
//商家店铺处实现添加菜品代码
//往后段发送图片
//参考推荐的代码，Recommend中是imagePath，在这里重新声明一个interface，将imagePath的图片转为base64

import { router } from "@kit.ArkUI";
import { HttpUtil } from '../../utils/HttpUtil';
import { ImageUtil } from '../../utils/ImageUtil';
import { Review } from '../../model/Review';
import { Shop } from '../../model/Shop';
import { FoodImage } from '../../model/FoodImage';
import { UserNameManager } from '../../utils/GlobalState'
import { FoodImageDialog } from "./FoodImageDialog";
import { ReviewInputDialog } from './ReviewDialog'
import { http } from '@kit.NetworkKit';
import { ShowToast } from "../../utils/ShowToast";

interface ShopDetailParams {
  shopId?: number;
}


@Entry
@Component
struct ShopDetail {
  @State shopId: number = 0;
  @State shopDetail: Shop | null = null;
  @State foodImages: FoodImage[] = [];
  @State reviews: Review[] = [];
  @State isLoading: boolean = true;
  @State activeTab: number = 0;

  @State rating: number = 0; // 当前评分（0-5）
  @State comment: string = ''; // 评论内容

  dialogController: CustomDialogController = new CustomDialogController({
    builder: FoodImageDialog({ shopId: this.shopId  }),
    alignment: DialogAlignment.Center, // 对齐方式为居中
    autoCancel: true,
    customStyle: false,
    height: '80%',
    width: '85%',
    cornerRadius: 16,
    backgroundColor: Color.White,
    // 添加滚动相关配置
    onWillDismiss: (action) => {
      if (action.reason === DismissReason.PRESS_BACK) {
        action.dismiss();
      }
    }
  });

  reviewInputDialog: CustomDialogController = new CustomDialogController({
    builder: ReviewInputDialog({ shopId: this.shopId  }),
    alignment: DialogAlignment.Center, // 对齐方式为居中
    autoCancel: true,
    customStyle: false,
    height: '50%',
    width: '85%',
    cornerRadius: 16,
    backgroundColor: Color.White,
    // 添加滚动相关配置
    onWillDismiss: (action) => {
      if (action.reason === DismissReason.PRESS_BACK) {
        action.dismiss();
      }
    }
  });

  private tabs: string[] = ['菜单', '评论'];

  aboutToAppear() {
    const params = router.getParams() as ShopDetailParams;
    if (params?.shopId !== undefined) {
      this.shopId = params.shopId;
      this.loadShopDetail();
      this.loadFoodImage();
      this.loadReview();
    }
  }

  async loadShopDetail() {
    this.isLoading = true;
    try {
      this.shopDetail = await HttpUtil.getShopDetail(this.shopId);
      console.log("我的名字"+this.shopDetail?.ownerName)
      console.log("我的名字two"+UserNameManager.getName())
    } catch (error) {
      console.error('加载店铺详情失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  async loadFoodImage() {
    try {
      this.foodImages = await HttpUtil.getFoodImageDetail(this.shopId);
    } catch (error) {
      console.error('加载菜单失败:', error);
    }
  }

  async loadReview() {
    try {
      this.reviews = await HttpUtil.getReviewDetail(this.shopId);
    } catch (error) {
      console.error('加载评论失败:', error);
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      this.buildHeader()

      if (this.isLoading) {
        this.buildLoading()
      } else if (this.shopDetail) {
        Column() {
          // 店铺基本信息卡片
          this.buildShopCard()

          // 选项卡
          this.buildTabs()

          // 内容区域
          this.buildContent()
        }
      } else {
        this.buildErrorState()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 顶部导航栏
  @Builder
  buildHeader() {
    Row() {
      Image($r('app.media.arrow_back'))
        .width(24)
        .height(24)
        .margin({ left: 16 })
        .onClick(() => router.back())

      Blank()
        .width('25%')

      Text('店铺详情')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16 })
    }
    .width('100%')
    .height(56)
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 2, color: '#1A000000', offsetX: 0, offsetY: 1 })
  }

  // 加载状态
  @Builder
  buildLoading() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .margin({ bottom: 16 })

      Text('加载中...')
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 错误状态
  @Builder
  buildErrorState() {
    Column() {
      Image($r('app.media.close'))
        .width(100)
        .height(100)
        .margin({ bottom: 16 })

      Text('加载店铺详情失败')
        .fontSize(18)
        .fontColor('#FF0000')
        .margin({ bottom: 8 })

      Text('请检查网络连接后重试')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 24 })

      Button('重新加载')
        .width(120)
        .height(40)
        .onClick(() => this.loadShopDetail())
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 店铺基本信息卡片
  @Builder
  buildShopCard() {
    Column() {
      if(this.shopDetail){
        // 店铺封面图
        Image(ImageUtil.getFullImageUrl(this.shopDetail.imagePath))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)

        // 店铺信息
        Column({ space: 8 }) {
          Row() {
            Text(this.shopDetail.shopName)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)

            Blank()

            // 评分
            Row({ space: 4 }) {
              Image($r('app.media.star'))
                .width(20)
                .height(20)
              Text(this.shopDetail.avgRating.toFixed(1))
                .fontSize(18)
                .fontColor('#FF9500')
            }
          }
          .width('100%')

          // 类别和营业时间
          Row({ space: 12 }) {
            Text(this.shopDetail.category)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor('#FF6A00')
              .borderRadius(12)

            Row({ space: 4 }) {
              Image($r('app.media.time_dialog'))
                .width(14)
                .height(14)
              Text(`${this.shopDetail.openTime} - ${this.shopDetail.closeTime}`)
                .fontSize(14)
                .fontColor('#666666')
            }
          }
          .width('100%')

          // 位置
          Row({ space: 4 }) {
            Image($r('app.media.location'))
              .width(16)
              .height(16)
            Text(this.shopDetail.location)
              .fontSize(14)
              .fontColor('#666666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')

          // 描述
          Text(this.shopDetail.description)
            .fontSize(14)
            .fontColor('#333333')
            .margin({ top: 8 })
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .padding(16)
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 12 })
    .borderRadius(12)
    .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }

  // 选项卡
  @Builder
  buildTabs() {
    Row() {
      ForEach(this.tabs, (tab: string, index: number) => {
        Column() {
          Text(tab)
            .fontSize(16)
            .fontColor(index === this.activeTab ? '#FF6A00' : '#666666')
            .padding({ bottom: 8 })

          if (index === this.activeTab) {
            Divider()
              .color('#FF6A00')
              .strokeWidth(2)
          }
        }
        .layoutWeight(1)
        .onClick(() => {
          this.activeTab = index;
        })
      })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .padding({ top: 12 })
  }

  // 内容区域
  @Builder
  buildContent() {
    Column() {
      if (this.activeTab === 0) {
        this.buildMenu()
      } else if (this.activeTab === 1) {
        this.buildReviews()
      }
    }
    .layoutWeight(1)
    .width('100%')
    .margin({ bottom: 20 }) // 与底部边距
  }

  // 菜单展示
  @Builder
  buildMenu() {
    Column() {
      if (this.foodImages.length === 0) {
        this.buildEmptyState('暂无菜单信息')
      } else {
        List() {
          ForEach(this.foodImages, (item: FoodImage) => {
            ListItem() {
              this.buildMenuItem(item)
            }
          })
        }
        .scrollBar(BarState.Auto)
        .divider({ strokeWidth: 1, color: '#EEEEEE', startMargin: 16, endMargin: 16 })
        .width('100%')
        .layoutWeight(1)
      }
      // 如果是这家店铺的商家则可以在这里添加新菜品
      if(this.shopDetail?.ownerName == UserNameManager.getName()){
        Button('添加菜品')
          .width('90%')
          .height(48)
          .margin(16)
          .backgroundColor('#FF6A00')
          .onClick(() => this.addFoodImage())
      }
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }

  // 菜单项组件
  @Builder
  buildMenuItem(item: FoodImage) {
    Row({ space: 12 }) {
      // 菜品图片
      Image(ImageUtil.getFullImageUrl(item.imagePath))
        .width(80)
        .height(80)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      // 菜品信息
      Column({ space: 4 }) {
        Text(item.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('100%')

        Text(item.description || '暂无描述')
          .fontSize(14)
          .fontColor('#666666')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          Text(`¥${item.price.toFixed(2)}`)
            .fontSize(16)
            .fontColor('#FF6A00')
            .fontWeight(FontWeight.Bold)

          Blank()
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .margin({bottom: 5})
  }

  // 评论展示
  @Builder
  buildReviews() {
    Column() {
      if (this.reviews.length === 0 || this.reviews === null) {
        this.buildEmptyState('暂无评论')
      } else {
        List() {
          ForEach(this.reviews, (review: Review) => {
            ListItem() {
              this.buildReviewItem(review)
            }
          })
        }
        .divider({ strokeWidth: 1, color: '#EEEEEE', startMargin: 16, endMargin: 16 })
        .width('100%')
        .layoutWeight(1)
      }
      // 添加评论按钮
      Button('添加评论')
        .width('90%')
        .height(48)
        .margin(16)
        .backgroundColor('#FF6A00')
        .onClick(() => this.reviewInputDialog.open())
    }
    .width('100%')
    .height('100%') // 确保父容器有高度
    .layoutWeight(1)
  }

  // 评论项组件
  @Builder
  buildReviewItem(review: Review) {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        // 用户头像
        Image($r(`app.media.${review.avatar.replace('.jpg', '')}`))
          .width(40)
          .height(40)
          .borderRadius(20)

        // 用户信息和评分
        Column({ space: 2 }) {
          Text(review.nickName|| '匿名用户')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)

          Row({ space: 4 }) {
            ForEach(Array.from({ length: 5 }), (item: undefined, index) => {
              if (index < Math.floor(review.rating)) {
                Image($r('app.media.star_filled'))
                  .width(16)
                  .height(16)
              } else if (index < review.rating) {
                Image($r('app.media.star_half'))
                  .width(16)
                  .height(16)
              } else {
                Image($r('app.media.star'))
                  .width(16)
                  .height(16)
              }
            })
          }
        }
        .layoutWeight(1)

        // 评论时间
        Text(this.formatIsoTimestamp(review.createdAt) || '未知时间')
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')

      // 评论内容
      Text(review.content)
        .fontSize(14)
        .fontColor('#333333')
        .margin({ top: 8 })

    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .margin({bottom: 5})
  }

  // 空状态组件
  @Builder
  buildEmptyState(message: string) {
    Column() {
      Image($r('app.media.empty_state'))
        .width(100)
        .height(100)
        .opacity(0.6)
        .margin({ bottom: 16 })

      Text(message)
        .fontSize(16)
        .fontColor('#999999')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .layoutWeight(1)
  }

  addFoodImage(){
    this.dialogController.open()
  }

  formatIsoTimestamp(isoTimestamp: string): string {
    if (!isoTimestamp) {
      return '';
    }

    try {
      // 创建日期对象
      const date = new Date(isoTimestamp);

      // 提取年月日时分秒
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      const seconds = String(date.getSeconds()).padStart(2, '0');

      // 返回格式化后的字符串
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    } catch (error) {
      console.error('格式化时间戳出错:', error);
      return isoTimestamp; // 返回原始字符串作为备选
    }
  }
}

export default ShopDetail;