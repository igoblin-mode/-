import { router } from '@kit.ArkUI';
import {http} from '@kit.NetworkKit';
import { ShowToast } from '../utils/ShowToast';
import {HttpUtil} from '../utils/HttpUtil'
import {UserNameManager, userNameStorage, USER_NAME_KEY} from '../utils/GlobalState'

interface LoginData{
  userName: string;
  password: string;
}

@Entry
@Component
struct Index {

  //用于操作全局的用户名
  @StorageLink(USER_NAME_KEY) username: string = '';

  @State message: string = '探店新发现，美味无边界';
  title: string = '美食探店'

  //@State username: string = ''
  @State password: string = ''
  @State errorMessage: string = ''

  @State isManagerDialogVisible: boolean = false;
  @State managerPassword: string = '';

  build() {
    Stack(){
      Column() {
        Image($r('app.media.software_icon'))
          .width(50)
          .margin({ top: 30 })
        Text(this.title)
          .fontSize(35)
          .fontWeight(900)
          .margin({ top: 20, bottom: 20 })
        Text(this.message)
          .fontSize(16)
          .fontColor('#666')
          .margin({ bottom: 50 })

        // 密码登录
        Column() {
          TextInput({
            placeholder: '账号(test顾客:123,商家:246)'
          })
            .maxLength(20)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.username = value
            })
          TextInput({
            placeholder: '密码'
          })
            .type(InputType.Password)
            .margin({ top: 20, bottom: 30 })
            .onChange((value: string) => {
              this.password = value
            })

          if (this.errorMessage){
            Text(this.errorMessage)
              .fontSize(14)
              .margin(10)
              .fontColor('#FF0000')
          }

          Row() {
            Text('注册账号')
              .fontColor('#007dff')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Register/Register',
                })
              })
            Row() {
              Text('管理审批')
                .fontColor('#007dff')
                .onClick(() => this.isManagerDialogVisible = true)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 10, right: 10 })
          .margin({ bottom: 25 })

          Button('登录')
            .width('100%')
            .onClick(() => this.handleLogin())
            .margin({ bottom: 15 })
        }
        .width("100%")
        .height('100%')
        .padding(20)

        if(this.isManagerDialogVisible){
          Column() {
            // 半透明遮罩
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor('#000000')
              .opacity(0.5)
              .onClick(() => {
                this.isManagerDialogVisible = false;
              })
            //弹窗内容
            Column() {
              Text('请输入管理员秘钥')
                .fontSize(24)
                .margin({ bottom: 20 })

              TextInput({ placeholder: '秘钥(2468)' })
                .width('90%')
                .height(120)
                .backgroundColor('#FFF')
                .type(InputType.Password)
                .onChange(v => this.managerPassword = v)

              Row() {
                Button('取消')
                  .onClick(() => this.isManagerDialogVisible = false)

                Button('确认')
                  .onClick(() => {
                    if(this.managerPassword === '2468'){
                      router.pushUrl({url:'pages/Manager'});
                    }else{
                      ShowToast("管理秘钥错误");
                    }
                  })
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('100%')
            }
            .width('90%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .position({ x: '5%' })
            .margin({ top: '20%' })
          }
          .position({ x: 0, y: 0 })
          .width('100%')
          .height('100%')
          .zIndex(999)
        }
      }
    }
  }

  async handleLogin(): Promise<void> {
    if (!this.username||!this.password) {
      this.errorMessage='用户名和密码不能为空'
      return
    }
    let loginData:LoginData={
      userName:this.username,
      password: this.password
    }
    let httpRequest = http.createHttp()
    const response = await httpRequest.request(
      `${HttpUtil.BASE_URL}/login`,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(loginData) //将登录参数转化为JSON格式
      }
    )
    console.log(response.result.toString())
    let result=response.result.toString()
    if (result.includes('登录成功')) {
      console.info("我的提示：登录成功")
      router.pushUrl({url:'pages/MainPage'})
    }else {
      this.errorMessage='用户名或者密码错误'
    }
  }
}
