import { router } from "@kit.ArkUI";
import {ShowToast} from './../../utils/ShowToast'
import {HttpUtil} from '../../utils/HttpUtil'
import {UserNameManager, userNameStorage} from './../../utils/GlobalState'
import { http } from '@kit.NetworkKit';
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { abilityAccessCtrl } from "@kit.AbilityKit";
import fileIo from '@ohos.file.fs';
import util from '@ohos.util';
import { dataSharePredicates } from "@kit.ArkData";

interface ApplyData{
  userName: string
  shopName: string
  shopLocation: string
  shopDescription: string
  shopCategory: string
  openTime: string
  closeTime: string
  shopImage?: string
}

@CustomDialog
@Component
export struct BusinessDialog {
  controller: CustomDialogController;
  title: string = '请填写您店铺的信息。'

  @State shopName: string = '';
  @State location: string = '';
  @State description: string = '';

  @State selectedImage: string = ''; // 存储选中的图片路径
  @State isImageSelected: boolean = false; // 标记是否已选择图片
  @State imagePreview: string = 'app.media.software_icon';//图片路径地址
  @State imageBase64: string = ''; // 存储Base64格式的图片数据

  //商家上班跟下班时间
  @State openTime: Date = new Date();
  @State closeTime: Date = new Date();
  //商家的主营商品选择
  @State selectedValue: string = '甜品饮品'
  @State showOptions: boolean = false // 控制下拉显隐

  @State selectedCategory: string = '';  // 保存选中分类
  @State isCategoryDialogVisible: boolean = false; // 控制下拉框显示

  // 自定义时间格式化函数
  private formatTime(date: Date): string {
    if (!(date instanceof Date)) return '--:--'; // 异常处理
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
  }

  build() {
    Stack() {
      // 添加滚动容器
      Scroll() {
        Column() {
          Text(this.title)
            .fontSize(16)
            .fontColor('#666')
            .margin({ top: 10, bottom: 10 })
          // 表单内容
          Row() {
            Text('店名:')
              .margin({ left: 10 })
            TextInput()
              .maxLength(20)
              .height(50)
              .fontSize(16)
              .backgroundColor('#F5F5F5')
              .onChange((newValue) => {
                this.shopName = newValue
              });
          }
          .width('90%')
          .height(50)
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30 })
          .backgroundColor('#F5F5F5')

          Row() {
            Text('位置:')
              .margin({ left: 10 })
            TextInput()
              .maxLength(20)
              .height(50)
              .fontSize(16)
              .backgroundColor('#F5F5F5')
              .onChange((newValue) => {
                this.location = newValue
              });
          }
          .width('90%')
          .height(50)
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30 })
          .backgroundColor('#F5F5F5')

          Row() {
            Text('简介:')
              .margin({ left: 10 })
              .height(100)
            TextArea()
              .height(100)
              .fontSize(16)
              .backgroundColor('#F5F5F5')
              .onChange((newValue) => {
                this.description = newValue
              });
          }
          .width('90%')
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30 })
          .backgroundColor('#F5F5F5')

          //分类
          Row() {
            Text('分类:')
              .margin({ left: 10 })

            Column() {
              // 点击区域
              Flex({ alignItems: ItemAlign.Center }) {
                Text(this.selectedValue)
                  .fontSize(16)
                  .fontColor('#666')
                  .margin({ left: 35 })

                Image($r("app.media.arrow_down"))
                  .width(20)
                  .margin({ left: 70 })
                  .rotate({ angle: this.showOptions ? 180 : 0 })
              }
              .height(50)
              .padding({ left: 10, right: 10 })
              .backgroundColor('#F5F5F5')
              .onClick(() => {
                this.showOptions = !this.showOptions
              })

              // 下拉选项区域
              if (this.showOptions) {
                Column() {
                  ForEach(['甜品饮品', '米粉面条', '炒菜盖饭', '快餐小吃'], (item: string) => {
                    Text(item)
                      .fontSize(16)
                      .height(40)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .padding({ left: 10 })
                      .backgroundColor('#FFF')
                      .onClick(() => {
                        this.selectedValue = item
                        this.showOptions = false
                      })
                  })
                }
                .width('90%')
                .margin({ top: 4, left: 15 })
                .borderRadius(8)
                .shadow({ radius: 4, color: '#1A000000' })
                .position({ x: '5%', y: 50 }) // 调整x位置确保对齐
                .zIndex(999) // 提高层级
              }
            }
            .width('90%')
            .zIndex(999) // 父容器也需提高层级
          }
          .width('95%')
          .height(50)
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30, left: 10 })
          .backgroundColor('#F5F5F5')
          .zIndex(this.showOptions ? 999 : 0) // 动态调整层级

          //开店时
          Row() {
            Text('开店时:')
              .margin({ left: 10 })
            Row() {
              Text(this.formatTime(this.openTime))
                .fontColor('#666')
                .margin({ right: 80 })
              Image($r('app.media.time_dialog'))
                .width(20)
                .fillColor('#666')
            }
          }
          .onClick(() => {
            this.getUIContext().showTimePickerDialog({
              selected: this.openTime,
              useMilitaryTime: true,
              textStyle: { color: '#2787d9', font: { size: '14fp', weight: FontWeight.Normal } },
              selectedTextStyle: { color: '#004aaf', font: { size: '18fp', weight: FontWeight.Regular } },
              acceptButtonStyle: {
                fontColor: '#2787d9',
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              cancelButtonStyle: {
                fontColor: Color.Red,
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              onAccept: (value: TimePickerResult) => {
                // 设置selectTime为按下确定按钮时的时间，这样当弹窗再次弹出时显示选中的为上一次确定的时间
                if (value.hour != undefined && value.minute != undefined) {
                  this.openTime.setHours(value.hour, value.minute)
                  console.info("我的错误TimePickerDialog:onAccept()" + JSON.stringify(value))
                }
              }
            })
          })
          .width('95%')
          .height(50)
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30, left: 10 })
          .backgroundColor('#F5F5F5')

          //休息时
          Row() {
            Text('休息时:')
              .margin({ left: 10 })
            Row() {
              Text(this.formatTime(this.closeTime))
                .fontColor('#666')
                .margin({ right: 80 })
              Image($r('app.media.time_dialog'))
                .width(20)
                .fillColor('#666')
            }
          }
          .onClick(() => {
            this.getUIContext().showTimePickerDialog({
              selected: this.closeTime,
              useMilitaryTime: true,
              textStyle: { color: '#2787d9', font: { size: '14fp', weight: FontWeight.Normal } },
              selectedTextStyle: { color: '#004aaf', font: { size: '18fp', weight: FontWeight.Regular } },
              acceptButtonStyle: {
                fontColor: '#2787d9',
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              cancelButtonStyle: {
                fontColor: Color.Red,
                fontSize: '16fp',
                backgroundColor: '#f7f7f7',
                borderRadius: 10
              },
              onAccept: (value: TimePickerResult) => {
                // 设置selectTime为按下确定按钮时的时间，这样当弹窗再次弹出时显示选中的为上一次确定的时间
                if (value.hour != undefined && value.minute != undefined) {
                  this.closeTime.setHours(value.hour, value.minute)
                  console.info("我的错误TimePickerDialog:onAccept()" + JSON.stringify(value))
                }
              }
            })
          })
          .width('95%')
          .height(50)
          .borderRadius(20)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: 30 })
          .margin({ top: 30, left: 10 })
          .backgroundColor('#F5F5F5')

          // 图片上传区域
          Column() {
            Text('上传店铺照片：').fontSize(18)

            // 图片预览区域
            if (this.isImageSelected) {
              Image(this.imagePreview)
                .width(150)
                .height(150)
                .objectFit(ImageFit.Contain)
                .borderRadius(8)
                .margin({ bottom: 10 })
                .onClick(() => {
                  // 点击预览图可以重新选择图片
                  this.pickImage();
                })
            } else {
              // 添加图片按钮
              Button('+ 添加店铺图片', { type: ButtonType.Normal })
                .width(150)
                .height(150)
                .backgroundColor(Color.White)
                .border({
                  width: 1,
                  color: '#ccc',
                  style: BorderStyle.Dashed
                })
                .onClick(() => {
                  this.pickImage();
                })
            }
          }.margin({ bottom: 20 })

          Row() {
            Blank()
            Button('提交申请')
              .width('80%')
              .height(50)
              .fontSize(18)
              .onClick(() => {
                if (!this.shopName || !this.location || !this.description) {
                  ShowToast('所有输入框均不能为空');
                  return
                }else{
                  this.SubmitApplication();
                }
              })
            Blank()
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 40 })
        }
        .padding(20) // 保持内容边距
      }
      .scrollable(ScrollDirection.Vertical) // 启用垂直滚动
      .scrollBar(BarState.Auto) // 自动显示滚动条
      .scrollBarColor(Color.Gray) // 滚动条颜色
      .scrollBarWidth(4) // 滚动条宽度

      Image($r('app.media.close'))
        .width(40)
        .height(40)
        .position({ x: '80%', y: '4%' })
        .onClick(() => this.controller.close())
        .zIndex(999)
    }
    .width('100%')
    .height('100%')
  }

  // 在组件类中添加权限申请方法
  // async requestPermission() {
  //   const atManager = abilityAccessCtrl.createAtManager();
  //   try {
  //     await atManager.requestPermissionsFromUser(getContext(this), ['ohos.permission.READ_MEDIA']);
  //     return true;
  //   } catch (err) {
  //     console.error('权限申请失败:', err);
  //     return false;
  //   }
  // }

  async pickImage(): Promise<void> {
    // 申请权限
    // const hasPermission = await this.requestPermission();
    // if (!hasPermission) {
    //   ShowToast('需要相册访问权限');
    //   return;
    // }

    try {
      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result: photoAccessHelper.PhotoSelectResult = await photoPicker.select({
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1
      });

      if (result.photoUris && result.photoUris.length > 0) {
        const uri = result.photoUris[0];
        console.info('我的提示已选择图片: ' + uri);

        //更新预览状态
        this.selectedImage = uri;
        this.isImageSelected = true;
        this.imagePreview = uri;

      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`我的错误选择图片失败: ${err.code}, ${err.message}`);
      ShowToast('选择图片失败');
    }
  }

  async SubmitApplication(): Promise<void> {

    // 如果有选中的图片，转换为 Base64
    if (this.isImageSelected && this.selectedImage) {
      try {
        const base64String = await this.imageToBase64(this.selectedImage);
        this.imageBase64 = base64String;
      } catch (error) {
        console.error(`我的错误图片转换失败: ${error}`);
        ShowToast('图片处理失败，请重试');
        return;
      }
    }

    let applyData: ApplyData={
      userName: UserNameManager.getName(),
      shopName: this.shopName,
      shopLocation: this.location,
      shopDescription: this.description,
      shopCategory: this.selectedValue,
      openTime: this.formatUTCToBeijingTime(this.openTime),
      closeTime: this.formatUTCToBeijingTime(this.closeTime),
      shopImage: this.imageBase64
    }
    let httpRequest = http.createHttp()
    const response = await httpRequest.request(
      `${HttpUtil.BASE_URL}/applyShop`,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(applyData)
      }
    )
    console.log('我的提示'+response.result.toString())
    let result=response.result.toString()
    if (result.includes('申请提交成功')) {
      ShowToast('申请已提交，等待审核中...');
    }else {
      ShowToast('申请提交失败，店铺可能已存在');
    }
  }

  // 将图片转换为 Base64
  async imageToBase64(uri: string): Promise<string> {
    try {
      console.log(`我的提示正在处理图片URI: ${uri}`);

      // 获取上下文
      const context = getContext(this) as Context;
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

      // 创建查询谓词
      const predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);

      const fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [], // 不需要额外列
        predicates: predicates
      };

      // 获取匹配的资源
      const fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
        await phAccessHelper.getAssets(fetchOptions);

      const photoAsset: photoAccessHelper.PhotoAsset | undefined = await fetchResult.getFirstObject();

      // 确保资源存在
      if (!photoAsset) {
        throw new Error(`未找到URI对应的资源: ${uri}`);
      }

      console.log(`我的提示成功获取资源: ${photoAsset.uri}`);

      // 使用Promise封装异步操作
      return new Promise<string>((resolve, reject) => {
        // 创建自定义数据处理类
        class CustomMediaHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
          onDataPrepared(data: ArrayBuffer) {
            try {
              if (!data || data.byteLength === 0) {
                reject(new Error('接收到的图片数据为空'));
                return;
              }

              console.log(`我的提示图片数据大小: ${data.byteLength} 字节`);

              // 转换为Base64
              const base64Helper = new util.Base64Helper();
              const base64String = base64Helper.encodeToString(new Uint8Array(data));

              resolve(base64String);
            } catch (error) {
              reject(new Error(`数据处理失败: ${error.message}`));
            }
          }
        }

        // 设置请求选项
        const requestOptions: photoAccessHelper.RequestOptions = {
          deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
        };

        // 请求图片数据
        photoAccessHelper.MediaAssetManager.requestImageData(
          context,
          photoAsset,
          requestOptions,
          new CustomMediaHandler()
        ).catch((err: BusinessError) => {
          reject(new Error(`请求图片数据失败: ${err.message}`));
        });
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`我的错误图片转换失败: code=${err.code}, message=${err.message}`);
      throw new Error(`图片处理失败: ${err.message}`);
    }
  }

  // 工具函数：UTC时间转北京时间（格式：XX时XX分XX秒）
  formatUTCToBeijingTime(utcDate: Date): string {

    //转换为北京时间（UTC+8）
    const beijingDate = new Date(utcDate.getTime() + 8 * 60 * 60 * 1000);

    //获取时间组件
    const hours = beijingDate.getUTCHours().toString().padStart(2, '0');
    const minutes = beijingDate.getUTCMinutes().toString().padStart(2, '0');
    const seconds = beijingDate.getUTCSeconds().toString().padStart(2, '0');

    //格式化为字符串
    return `${hours}:${minutes}:${seconds}`;
  }
}

