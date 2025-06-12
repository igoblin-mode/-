import { router } from '@kit.ArkUI';
import { Recommendation } from '../../model/Recommendation';
import { HttpUtil } from '../../utils/HttpUtil';
import { ImageUtil } from '../../utils/ImageUtil';

interface Author{
  name: string;
  avatar: Resource;
}

interface RecommendationIdParams{
  recommendationId?: number;
}

@Entry
@Component
struct RecommendDetailPage {
  @State recommendation: Recommendation = {
    recommendationId: 0,
    nickName: "",
    avatar: "",
    shopName: "",
    title: "",
    shopLocation: "",
    description: "",
    imagePaths: []
  };
  @State currentImageIndex: number = 0;
  @State isLiked: boolean = false;
  @State likeCount: number = 0;
  @State recommendationId: number = 0;

  aboutToAppear() {
    const parms = router.getParams() as RecommendationIdParams
    if( parms.recommendationId!=undefined ){
      this.recommendationId = parms.recommendationId
    }

    this.loadRecommendation();
  }

  async loadRecommendation() {
    this.recommendation = await HttpUtil.getRecommendationById(this.recommendationId);
  }

  // 切换图片
  handleImageChange(index: number) {
    this.currentImageIndex = index;
  }

  // 点赞功能
  toggleLike() {
    this.isLiked = !this.isLiked;
    this.likeCount = this.isLiked ? this.likeCount + 1 : this.likeCount - 1;
  }

  build() {
    Column() {
      // 返回按钮 - 添加在最顶层
      Image($r('app.media.arrow_back'))
        .width(26)
        .margin({ left: 20, top: 20 })
        .onClick(() => {
          router.back()
        })
        .position({ x: 0, y: 0 }) // 定位到左上角
        .zIndex(2) // 确保在最上层显示

      Scroll(){
        Column(){
          // 顶部图片轮播区域
          Stack({ alignContent: Alignment.TopEnd }) {
            // 图片轮播
            Swiper() {
              ForEach(this.recommendation.imagePaths, (image: string, index) => {
                Image(ImageUtil.getFullImageUrl(image))
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Cover)
              })
            }
            .indicator(false) // 禁用默认指示器
            .autoPlay(false)
            .onChange((index: number) => {
              this.currentImageIndex = index;
            })
            .height('65%')

            // 自定义图片索引指示器
            Row() {
              Text(`${this.currentImageIndex + 1}/${this.recommendation.imagePaths.length}`)
                .fontSize(14)
                .fontColor(Color.White)
                .padding(4)
            }
            .padding({ left: 10, right: 10, top: 4, bottom: 4 })
            .backgroundColor('#00000055')
            .borderRadius(12)
            .margin({ top: 40, right: 20 })
          }

          // 用户信息区域
          Row({ space: 10 }) {
            Image($r(`app.media.${this.recommendation.avatar.replace('.jpg', '')}`))
              .width(50)
              .height(50)
              .borderRadius(25)
              .objectFit(ImageFit.Cover)

            Column({ space: 3 }) {
              Text(this.recommendation.nickName)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin({right:120})

            }
            .layoutWeight(1)

            // 待实现
            // Button('关注')
            //   .width(70)
            //   .height(30)
            //   .fontSize(14)
            //   .backgroundColor('#FFA500')
            //   .fontColor(Color.White)
            //   .borderRadius(15)
          }
          .padding(15)
          .width('100%')
          .backgroundColor(Color.White)

          // 店铺信息区域
          Column({ space: 10 }) {
            Row({ space: 5 }) {
              Text('店名:')
                .fontSize(16)
                .fontColor('#333')
                .fontWeight(FontWeight.Bold)
              Text(this.recommendation.shopName)
                .fontSize(16)
                .fontColor('#333')
            }

            Row({ space: 5 }) {
              Text('位置:')
                .fontSize(16)
                .fontColor('#333')
                .fontWeight(FontWeight.Bold)
              Text(this.recommendation.shopLocation)
                .fontSize(16)
                .fontColor('#333')
            }
          }
          .padding(15)
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 10 })

          // 推荐理由区域
          Column({ space: 10 }) {
            Text('推荐理由')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333')

            Text(this.recommendation.description)
              .fontSize(16)
              .fontColor('#444')
              .lineHeight(24)
          }
          .padding(15)
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 10 })

          Blank()
            .height('30')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
