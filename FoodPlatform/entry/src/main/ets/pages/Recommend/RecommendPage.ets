//顾客信息还未从后端处获取

import { router } from '@kit.ArkUI'
import { http } from '@kit.NetworkKit'
import { HttpUtil } from '../../utils/HttpUtil'
import { Recommendation, RecommendationImage, Author} from '../../model/Recommendation'
import { ImageUtil } from '../../utils/ImageUtil';
import { UserNameManager } from '../../utils/GlobalState'
import { ShowToast } from '../../utils/ShowToast';


@Component
struct RecommendPage {
  @State isLoading: boolean = true;
  @State errorMsg: string = '';
  @State recommendationList: Recommendation[] = [];

  onPageShow() {
    this.fetchRecommendations();
  }

  aboutToAppear() {
    this.fetchRecommendations();
  }

  // 从后端获取推荐数据
  async fetchRecommendations() {
    try{
      const result = await HttpUtil.getRandomRecommendation(30);

      // 将List转换为数组
      const recommendationArray: Recommendation[] = [];
      for(let i = 0; i < result.length; i++){
        recommendationArray.push(result[i]);
      }
      this.recommendationList = recommendationArray;
      this.isLoading = false;
    }catch (error){

    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Stack() {
        Image($r('app.media.background_foodie'))
          .width('100%')
          .height(100)
          .opacity(0.5)

        Row() {
          Text('美食指南针')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .padding(16)
        .borderRadius(40)
        .backgroundColor('#CCFFFFFF')
      }
      .width('100%')
      .height(100)

      // 加载状态显示
      if (this.isLoading) {
        Column() {
          Image($r('app.media.avatar4'))
            .width(40)
            .height(40)
            .animation({
              duration: 1000,
              iterations: -1,
              curve: Curve.Linear
            })
          Text('加载中...')
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      // 错误状态显示
      else if (this.errorMsg) {
        Column() {
          Image($r('app.media.arrow_down'))
            .width(40)
            .height(40)
          Text(this.errorMsg)
            .margin({ top: 10 })
          Button('重试')
            .margin({ top: 20 })
            .onClick(() => this.fetchRecommendations())
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      // 数据显示
      else if (this.recommendationList.length === 0) {
        Column() {
          Image($r('app.media.comments'))
            .width(60)
            .height(60)
          Text('暂无推荐数据')
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      else {
        // 双列瀑布流
        Grid() {
          ForEach(this.recommendationList, (recommendation: Recommendation) => {
            GridItem() {
              Column({ space: 8 }) {
                // 图片区域
                Image(ImageUtil.getFullImageUrl(recommendation.imagePaths[0]))
                  .width('100%')
                  .aspectRatio(0.8)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(12)

                // 标题
                Text(recommendation.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                // 内容(只显示前八个字符)
                Text(recommendation.description.length > 8
                  ? recommendation.description.substring(0, 8) + '...'
                  : recommendation.description,)
                  .fontSize(14)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                // 用户信息
                Row() {
                  Image($r(`app.media.${recommendation.avatar.replace('.jpg', '')}`))
                    .width(24)
                    .height(24)
                    .borderRadius(12)
                    .margin({ right: 8 })

                  Text(recommendation.nickName)
                    .fontSize(12)
                    .fontColor('#666')
                }
                .width('100%')
                .alignItems(VerticalAlign.Center)
              }
              .padding(8)
              .backgroundColor('#ffffff')
              .borderRadius(12)
              .onClick(async () => {
                router.pushUrl({
                  url: 'pages/Recommend/RecommendDetail',
                  params: {
                    recommendationId: recommendation.recommendationId,
                  }
                })
              })
            }
            .margin(4)
          })
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(8)
        .padding(8)
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      }
    }
    .height('100%')
    .backgroundColor('#ffffff')
  }
}

export default RecommendPage

