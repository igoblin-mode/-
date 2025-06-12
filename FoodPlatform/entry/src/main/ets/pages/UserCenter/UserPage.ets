import { BusinessDialog } from '../Register/BusinessDialog';
import { MyShopDialog } from '../UserCenter/MyShopDialog'
import { UserNameManager, userNameStorage, USER_NAME_KEY } from '../../utils/GlobalState'
import { User } from '../../model/User'
import {ShowToast} from '../../utils/ShowToast'
import { MyReview } from '../../model/MyReview';
import { HttpUtil } from '../../utils/HttpUtil';
import { router } from '@kit.ArkUI';
import { MyRecommendation } from '../../model/Recommendation';
import { ImageUtil } from '../../utils/ImageUtil';
import { changeDialog } from './changeDialog';

@Entry
@Component
struct UserPage {
  //用于操作全局的用户名
  @StorageLink(USER_NAME_KEY) username: string = '';
  // 用户信息
  @State userName: string = "美食探险家";
  @State isBusiness: boolean = false; // 用户身份标识
  @State user: User = {
    userId: 0,
    userName: '',
    password: '',
    nickName: '',
    avatar: '',
    role: '',
    createdAt: '',
    businessStatus: ''
  }
  @State myReview: MyReview[] = []
  @State myRecommendation: MyRecommendation[] = []

  // 存储修改的头像和昵称
  @State tempAvatarIndex: number = 0;
  @State tempNickName: string = '';

  dialogController: CustomDialogController = new CustomDialogController({
    builder: BusinessDialog(),
    alignment: DialogAlignment.Center, // 对齐方式为居中
    autoCancel: true,
    customStyle: false,
    height: '75%',
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

  myShopDialogController: CustomDialogController = new CustomDialogController({
    builder: MyShopDialog(),
    alignment: DialogAlignment.Center, // 对齐方式为居中
    autoCancel: true,
    customStyle: false,
    height: '75%',
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

  changeDialogController: CustomDialogController = new CustomDialogController({
    builder: changeDialog({
      userId: this.user.userId,
      avatar: $tempAvatarIndex, // 绑定临时头像索引
      name: $tempNickName,     // 绑定临时昵称
    }
    ),
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

  build() {
    Stack() {
      Column() {
        // 用户信息区域
        Column() {
          // 头像选择
          Row() {
            Image($r(`app.media.avatar${this.tempAvatarIndex}`))
              .width(60)
              .height(60)
              .margin(5)
            Column(){
              Text(`昵称:${this.tempNickName}`)
                .fontSize(18)
                .margin({bottom:10})
              Text(this.user.role === 'customer' ? '身份：顾客' : '身份：商家')
            }
            Button('修改')
            .type(ButtonType.Normal)
            .backgroundColor('#ADD8E6')
            .borderColor('#cccccc')
            .borderWidth(1)
            .borderRadius(20)
            .width(50)
            .height(40)
            .padding(0)
            .margin({ left: '10' })
            .onClick(() => {
              this.changeDialogController.open()
            })
          }
        }
        .padding(15)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ bottom: 20 })

        // 历史记录
        Tabs() {
          TabContent() {
            if(this.myReview.length === 0){
              Column() {
                Image($r('app.media.comments'))
                  .width(60)
                  .height(60)
                Text('暂未写过评价数据')
                  .margin({ top: 10 })
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
            }else{
              List({ space: 10 }) {
                ForEach(this.myReview, (myReview: MyReview) => {
                  ListItem() {
                    this.buildMyReview(myReview)
                  }
                  .onClick(() => {
                    // 跳转到评论的店铺
                    router.pushUrl({
                      url: 'pages/Shop/ShopDetail',
                      params: {
                        shopId: myReview.shopId,  // 传递店铺ID
                      }
                    })
                  })
                })
              }
              .width('100%')
              .height('100%') // 设置List高度为100%，占满TabContent空间
            }
          }.tabBar('我的评价')

          //点击推荐的组件时，通过店铺名跟店铺地址查询是否有该店铺，有的话跳转，没有的话提示
          TabContent() {
            if(this.myRecommendation.length === 0){
              Column() {
                Image($r('app.media.comments'))
                  .width(60)
                  .height(60)
                Text('暂未写过推荐数据')
                  .margin({ top: 10 })
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
            }else{
              Grid() {
                ForEach(this.myRecommendation, (myRecommendation: MyRecommendation) => {
                  GridItem() {
                    Column({ space: 8 }) {
                      // 图片区域
                      Image(ImageUtil.getFullImageUrl(myRecommendation.imagePath))
                        .width('100%')
                        .aspectRatio(0.8)
                        .objectFit(ImageFit.Cover)
                        .borderRadius(12)

                      // 标题
                      Text(myRecommendation.title)
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })

                      // 内容
                      Text(myRecommendation.description)
                        .fontSize(14)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .padding(8)
                    .backgroundColor('#ffffff')
                    .borderRadius(12)
                    .onClick(async () => {
                      router.pushUrl({
                        url: 'pages/Recommend/RecommendDetail',
                        params: {
                          recommendationId: myRecommendation.recommendationId,
                        }
                      })
                    })
                  }
                  .margin(4)
                })
              }
              .columnsTemplate('1fr 1fr') // 两列布局
              .columnsGap(8)
              .rowsGap(8)
              .padding(8)
              .layoutWeight(1)
              .backgroundColor('#f5f5f5')
            }
          }.tabBar('我的推荐')
        }
        .barWidth(400)
        .barHeight(40)
        .width('100%')
        .height('74%') // 设置Tabs高度，避免占用过多空间

        // 功能入口
        Grid() {
          GridItem() {
            Column() {
              Image($r('app.media.shop_icon')) // 商家入口图标
                .width(40)
                .height(40)
              Text('我的店铺')
                .fontSize(16)
            }
            .onClick(() => {
              if (this.user.role === 'business') {
                this.myShopDialogController.open();
              }else{
                ShowToast("你还不是商家。")
              }
            })
          }

          GridItem() {
            Column() {
              Image($r('app.media.home')) // 转换身份图标
                .width(40)
                .height(40)
              Text('添加商铺')
                .fontSize(16)
            }
            .onClick(() => {
              this.dialogController.open();
            })
            .opacity(this.isBusiness ? 0.5 : 1)
          }
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(20)
        .columnsGap(20)
        //.margin({ bottom: 20 })
      }
      .padding(15)
      .width('100%')
      .backgroundColor('#f5f5f5')
    }
  }

  @Builder
  buildMyReview(item: MyReview){
    Stack() {
      Image($r('app.media.myReview_background'))
        .width('100%')
        .height(120)
        .opacity(0.5)

      Column({ space: 10 }){
        Row(){
          Text("店名："+item.shopName)
            .fontSize(20)
            .width('60%')
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({left:10})
          Row(){
            ForEach(Array.from({ length: 5 }), (_it: undefined, index) => {
              Image(index < item.rating ? $r('app.media.star_filled') : $r('app.media.star'))
                .width(20)
                .height(20)
                .margin(3)
            })
          }
          .width('40%') // 星星区域占据剩余宽度
        }
        .margin({ bottom: 5 })

        Row(){
          Image($r('app.media.location'))
            .width(20)
            .height(20)
            .margin({left:10})
          Text(item.location)
            .fontSize(18)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Text("评价："+item.content)
          .fontSize(16)
          .margin({left:14})
          .width('100%')
          .textAlign(TextAlign.Start) //靠左对其
      }
      .width('100%')
      .height(120)
      .borderRadius('20')
    }
  }

  onPageShow() {
    this.loadAllData();
  }

  aboutToAppear() {
    this.loadAllData();
  }

  // 封装数据加载方法
  async loadAllData() {
    try {
      await this.getUserInformation();
      await this.getMyReview();
      await this.getMyRecommendation();
    } catch (error) {
      console.error('数据加载失败', error);
    }
  }

  async getMyReview(){
    if(this.user.userId != 0){
      try{
        this.myReview = await HttpUtil.getMyReview(this.user.userId)
      }catch (error){
        console.error('getMyReview Error', error);
      }
    }
  }

  async getMyRecommendation(){
    try{
      this.myRecommendation = await HttpUtil.getMyRecommendation(this.user.userId)
    }catch (error){
      console.error('getMyRecommendation Error', error);
    }
  }

  async getUserInformation() {
    try {
      this.user = await UserNameManager.getUserInformation();
      // 初始化临时值
      this.tempAvatarIndex = parseInt(this.user.avatar.replace('avatar', '').replace('.jpg', ''));
      this.tempNickName = this.user.nickName;
    } catch (error) {
      console.error('getUserInformation Error', error);
    }
  }
}

export default UserPage