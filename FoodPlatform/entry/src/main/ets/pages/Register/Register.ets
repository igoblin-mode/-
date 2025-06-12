
import { router } from '@kit.ArkUI';
import { BusinessDialog } from './BusinessDialog'
import {HttpUtil} from '../../utils/HttpUtil'
import { http } from '@kit.NetworkKit';
import {ShowToast} from './../../utils/ShowToast'
import {UserNameManager, userNameStorage, USER_NAME_KEY} from './../../utils/GlobalState'

interface RegisterData{
  nickName: string;
  userName: string;
  password: string;
}

@Entry
@Component
struct Register{
  //用于操作全局的用户名
  @StorageLink(USER_NAME_KEY) username: string = '';

  @State message: string = '注册新账号，畅享新美味';
  title: string = '美食探店'

  @State role: string = 'customer';
  @State nickname: string = '';
  //@State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State errorMessage: string = '';

  @State textValue: string = '';
  @State inputValue: string = 'click me';

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

  //判断两次密码是否一致
  checkPasswordMatch(): boolean {
    if (this.password!== this.confirmPassword) {
      return false;
    }
    return true;
  }

  build() {
    Column(){
      Row() {
        Image($r('app.media.arrow_back'))
          .width(26)
          .margin({ left: 20, top: 20 })
          .onClick(() => {
            router.back()
          })
        // 左右侧空白占位（自动扩展剩余空间）
        Blank()
          .layoutWeight(0.74)  // 占据剩余空间
        Image($r('app.media.software_icon'))
          .width(50)
        Blank()
          .layoutWeight(1)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Text(this.title)
        .fontSize(35)
        .fontWeight(900)
        .margin({ top: 20, bottom: 10 })
      Text(this.message)
        .fontSize(18)
        .fontColor('#666')
        .margin({ bottom: 50 })

      Column() {
        TextInput({
          placeholder: '昵称',
        })
          .maxLength(20)
          .type(InputType.Normal)
          .margin({ left: 20, right: 20 })
          .height(60)
          .fontSize(20)
          .onChange((newValue) => {
            this.nickname = newValue;
          });
        TextInput({
          placeholder: '账号',
        })
          .maxLength(20)
          .type(InputType.Number)
          .margin({ top: 30, left: 20, right: 20 })
          .height(60)
          .fontSize(20)
          .onChange((newValue) => {
            this.username = newValue;
          });
        TextInput({
          placeholder: '密码'
        })
          .type(InputType.Password)
          .margin({ top: 30, left: 20, right: 20 })
          .height(60)
          .fontSize(20)
          .onChange((newValue) => {
            this.password = newValue
          })
        TextInput({
          placeholder: '再次输入密码'
        })
          .type(InputType.Password)
          .margin({ top: 30, left: 20, right: 20 })
          .height(60)
          .fontSize(20)
          .onChange((newValue) => {
            this.confirmPassword = newValue
          })

        Row() {
          Text('身份选择')
            .fontSize(18)
            .margin({ left:20,right: 20})
            .fontColor('#666')
          Divider()
            .vertical(true)
            .height(40)
            .width(4)
            .color('#007dff')
            .margin({ left: 10 , right: 10 })

          // 顾客选项
          Text('顾客')
            .fontSize(18)
            .padding({ left: 20, right: 20 })
            .height(50)
            .borderRadius(25)
            .backgroundColor(this.role === 'customer' ? '#FFE4B5' : '#FFFFFF') // 选中状态
            .onClick(() => {
              this.role = 'customer'
            })
          Divider()
            .vertical(true)
            .height(40)
            .width(4)
            .color('#007dff')
            .margin({ left: 10 , right: 10 })

          // 商家选项
          // 要注册为商家的话，需先填写完顾客信息，并先注册为顾客，提交的商铺信息等管理员审核
          // 通过了才将身份转变为商家
          Text('商家')
            .fontSize(18)
            .padding({ left: 20, right: 20 })
            .margin({right: 10})
            .height(50)
            .borderRadius(25)
            .backgroundColor(this.role === 'business' ? '#FFE4B5' : '#FFFFFF') // 选中状态
            .onClick(() => {
              this.role = 'business'
            })
        }
        .margin({ top: 40, left: 20 ,right: 20 })
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .height(60)

        Button('注册')
          .width('50%')
          .height('8%')
          .fontSize(25)
          .onClick(() => {
            if(this.checkPasswordMatch()){
              if (!this.nickname||!this.username||!this.password||!this.confirmPassword) {
                ShowToast('所有输入框均不能为空');
                return
              }
              if (this.password!==this.confirmPassword) {
                this.handleRegister();
                return
              }
              if(this.role === 'customer'){
                this.handleRegister();
              }else{
                this.handleRegister();
              }
            }
          })
          .margin({ top: 40 })
      }
    }
  }

  async handleRegister(): Promise<void> {
    let registerData:RegisterData={
      nickName: this.nickname,
      userName: this.username,
      password: this.password,
    }
    let httpRequest = http.createHttp()
    const response = await httpRequest.request(
      `${HttpUtil.BASE_URL}/register`,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(registerData) //将登录参数转化为JSON格式
      }
    )
    console.log(response.result.toString())
    let result=response.result.toString()
    if (result.includes('注册成功')) {
      //设置全局用户名
      UserNameManager.setName(this.username)
      // 添加延迟确保状态更新
      setTimeout(() => {
        if (this.role === 'customer') {
          ShowToast('注册成功，欢迎登录');
          router.pushUrl({ url: 'pages/Index' });
        } else {
          this.dialogController.open();
          ShowToast('已注册为顾客，提交店铺后等管理员审核');
        }
      }, 100);
    }else {
      ShowToast('注册失败，请检查账号是否已存在');
    }
  }

}