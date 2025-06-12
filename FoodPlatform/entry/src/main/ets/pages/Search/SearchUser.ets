import { User } from '../../model/User'
import { HttpUtil } from '../../utils/HttpUtil'
import { router } from '@kit.ArkUI';

@Observed
class UserClass implements User {
  // 定义接口要求的所有属性
  public userId: number;
  public userName: string;
  public password: string;
  public nickName: string;
  public avatar: string;
  public role: string;
  public createdAt: string;
  public businessStatus: string;

  // 构造函数，接收初始化数据
  constructor(userData: User) {
    this.userId = userData.userId;
    this.userName = userData.userName;
    this.password = userData.password;
    this.nickName = userData.nickName;
    this.avatar = userData.avatar;
    this.role = userData.role;
    this.createdAt = userData.createdAt;
    this.businessStatus = userData.businessStatus;
  }
}

@Component
struct SearchUser{
  @State users: User[] = []
  @Prop @Watch('onSearchMessage')searchMessage: string;

  onSearchMessage(newVal: string) {
    if (newVal) {
      this.loadSearchUser(); // 搜索词变化时重新加载
    }
  }

  aboutToAppear(): void {
    this.loadSearchUser()
  }

  //加载申请列表
  async loadSearchUser() {
    try{
      this.users = await HttpUtil.getSearchUser(this.searchMessage);
    }catch (error){
      console.error("获取用户搜索结果失败:", error);
    }
  }

  build() {
    if(this.users.length === 0){
      // 无数据状态
      Column() {
        Image($r('app.media.empty_state')) // 空状态图标资源
          .width(100)
          .height(100)
          .opacity(0.5)

        Text("暂无相关搜索用户")
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
        ForEach(this.users, (item: User) => {
          ListItem() {
            UserCard({
              user: item
            })
              .margin({ top: 20 })
          }
        }, (item: User) => item.userId.toString())
      }
      .padding(10)
      .scrollBar(BarState.Off)
    }
  }
}

@Component
struct UserCard {
  @ObjectLink user: UserClass;
  @State placeholderImage: Resource = $r('app.media.shop_placeholder'); // 占位图

  build() {
    Column(){
      Row() {
        // 左侧店铺图片
        Column() {
          // 显示店铺图片
          if (this.user.avatar) {
            Image($r(`app.media.${this.user.avatar.replace('.jpg', '')}`))
              .width(100)
              .height(100)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onError(() => {
                console.error('图片加载失败:', this.user.avatar);
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
          Text(`昵称：${this.user.nickName}`)
            .fontSize(14)
            .fontColor('#333')
            .margin({ bottom: 8,top: 14 })
            .width('100%')

          Text(this.user.role === 'customer' ? '身份：顾客' : '身份：商家')
            .fontSize(14)
            .fontColor('#666')
            .margin({ bottom: 4 })
            .width('100%')
        }
        .width('50%')
      }
      // 底部申请时间和描述
      Column() {
        Text(`创号时间：${this.formatIsoTimestamp(this.user.createdAt)}`)
          .fontSize(12)
          .fontColor('#666')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
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

export default SearchUser