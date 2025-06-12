import { Recommendation } from '../../model/Recommendation'
import { HttpUtil } from '../../utils/HttpUtil'
import { router } from '@kit.ArkUI';
import { ImageUtil } from '../../utils/ImageUtil';
import { ShowToast } from '../../utils/ShowToast';

@Observed
class RecommendationClass implements Recommendation {
  // 定义接口要求的所有属性
  public recommendationId: number;
  public nickName: string;
  public avatar: string;
  public shopName: string;
  public title: string;
  public shopLocation: string;
  public description: string;
  public imagePaths: string[];

  // 构造函数，接收初始化数据
  constructor(recommendationData: Recommendation) {
    this.recommendationId = recommendationData.recommendationId;
    this.nickName = recommendationData.nickName;
    this.avatar = recommendationData.avatar;
    this.shopName = recommendationData.shopName;
    this.title = recommendationData.title;
    this.shopLocation = recommendationData.shopLocation;
    this.description = recommendationData.description;
    this.imagePaths = recommendationData.imagePaths || [];
  }
}

@Component
struct SearchRecommend{

  @State recommendations: Recommendation[] = []
  @Prop @Watch('onSearchMessage')searchMessage: string; //从父组件获取的搜索信息

  onSearchMessage(newVal: string) {
    if (newVal) {
      this.loadSearchRecommend(); // 搜索词变化时重新加载
    }
  }

  aboutToAppear(): void {
    this.loadSearchRecommend()
  }

  //加载申请列表
  async loadSearchRecommend() {
    try{
      this.recommendations = await HttpUtil.getSearchRecommend(this.searchMessage);
    }catch (error){
      console.error("获取推荐搜索结果失败:", error);
    }
  }

  build() {
    if(this.recommendations.length === 0||this.recommendations === null){
      // 无数据状态
      Column() {
        Image($r('app.media.empty_state')) // 空状态图标资源
          .width(100)
          .height(100)
          .opacity(0.5)

        Text("暂无相关搜索推荐")
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
        ForEach(this.recommendations, (item: Recommendation) => {
          ListItem() {
            RecommendationCard({
              recommendation: item
            })
              .margin({ top: 20 })
          }
        }, (item: Recommendation) => item.recommendationId.toString())
      }
      .padding(10)
      .scrollBar(BarState.Off)
    }
  }
}

@Component
struct RecommendationCard {
  @ObjectLink recommendation: RecommendationClass;
  @State placeholderImage: Resource = $r('app.media.shop_placeholder'); // 占位图

  build() {
    Column(){
      Row() {
        // 左侧店铺图片
        Column() {
          // 显示店铺图片
          if (this.recommendation.imagePaths[0]) {
            Image(ImageUtil.getFullImageUrl(this.recommendation.imagePaths[0]))
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onError(() => {
                console.error('图片加载失败:', this.recommendation.imagePaths[0]);
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
          Text(`标题：${this.recommendation.title}`)
            .fontSize(14)
            .fontColor('#333')
            .margin({ bottom: 8,top: 14 })
            .width('100%')

          Text(`内容：${this.recommendation.description.length > 8
            ? this.recommendation.description.substring(0, 8) + '...'
            : this.recommendation.description}`) //只显示前八个字
            .fontSize(14)
            .fontColor('#666')
            .margin({ bottom: 4 })
            .width('100%')

          Row() {
            Image($r(`app.media.${this.recommendation.avatar.replace('.jpg', '')}`))
              .width(24)
              .height(24)
              .borderRadius(12)
              .margin({ right: 8 })
            Text(`${this.recommendation.nickName}`)
              .fontSize(12)
              .fontColor('#666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .width('50%')
      }
    }
    .borderRadius('20')
    .backgroundColor('#f1f3f5')
    .padding({
      left: 10,
      right: 10
    })
    .onClick(async () => {
      //店铺存在
      if(await HttpUtil.findShopIdByNameAndLocation(this.recommendation.shopName, this.recommendation.shopLocation)!=null){
        router.pushUrl({
          url: 'pages/Recommend/RecommendDetail',
          params: {
            recommendationId: this.recommendation.recommendationId,
          }
        })
      }else{
        ShowToast("当前推荐的店铺尚未入驻本软件")
      }
    })
  }
}

export default SearchRecommend