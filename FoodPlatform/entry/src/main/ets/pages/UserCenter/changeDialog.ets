import { UserNameManager } from "../../utils/GlobalState";
import { HttpUtil } from "../../utils/HttpUtil";
import { ShowToast } from "../../utils/ShowToast";
import { http } from "@kit.NetworkKit";

interface userData{
  userId: number,
  avatar: string,
  nickName: string
}

@CustomDialog
@Component
export struct changeDialog {
  controller: CustomDialogController;

  // 状态管理
  @State avatarSelected: number = 0; // 默认选择第一个头像
  @State nickname: string = '';      // 昵称输入值
  @State avatarOptions: Resource[] = [
    $r('app.media.avatar0'),
    $r('app.media.avatar1'),
    $r('app.media.avatar2'),
    $r('app.media.avatar3'),
    $r('app.media.avatar4'),
  ];

  // 用于将选择的头像和昵称传递给父组件
  @Prop userId: number;
  @Link avatar: number;
  @Link name: string;

  aboutToAppear() {
    // 初始化数据
    this.avatarSelected = this.avatar;
    this.nickname = this.name;
  }

  build() {
    Column() {
      // 标题
      Text('个人信息修改')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 头像选择区域
      Column() {
        Text('选择头像')
          .fontSize(16)
          .margin({ bottom: 10 })

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
          ForEach(this.avatarOptions, (item: Resource, index) => {
            Image(item)
              .width(60)
              .height(60)
              .borderRadius(30)
              .objectFit(ImageFit.Cover)
              .border({
                width: this.avatarSelected === index ? 3 : 0,
                color: this.avatarSelected === index ? '#007DFF' : '#FFFFFF'
              })
              .margin(10)
              .onClick(() => {
                this.avatarSelected = index;
              })
          })
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 昵称输入区域
      Column() {
        Text('修改昵称')
          .fontSize(16)
          .margin({ bottom: 10 })

        TextInput({placeholder: '请输入新昵称' ,text: this.nickname })
          .width('100%')
          .onChange((value) => {
            this.nickname = value;
          })
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 按钮区域
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .width('40%')
          .onClick(() => {
            this.controller.close();
          })

        Button('确认')
          .width('40%')
          .backgroundColor('#007DFF')
          .onClick(() => {
            // 更新父组件数据
            this.avatar = this.avatarSelected;
            this.name = this.nickname;
            this.updateUserInfo();
            this.controller.close();
          })
      }
      .width('100%')
    }
    .width('90%')
    .height('50%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(15)
  }
  // 更新用户信息
  async updateUserInfo() {
    try {

      const newUserData: userData = {
        userId: this.userId,
        avatar: `avatar${this.avatarSelected}.jpg`,
        nickName: this.nickname
      }

      let httpRequest = http.createHttp()
      const response = await httpRequest.request(
        `${HttpUtil.BASE_URL}/updateUserInfo`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(newUserData)
        }
      )
      ShowToast('个人信息更新成功');
    } catch (error) {
      ShowToast('更新失败，请重试');
      console.error('updateUserInfo error', error);
    }
  }
}