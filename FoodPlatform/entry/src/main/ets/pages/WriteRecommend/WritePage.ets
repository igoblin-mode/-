// EntryAbility.ets (页面入口)
import formBindingData from '@ohos.app.form.formBindingData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ShowToast } from '../../utils/ShowToast';
import { util } from '@kit.ArkTS';
import { dataSharePredicates } from '@kit.ArkData';
import { http } from '@kit.NetworkKit';
import { HttpUtil } from '../../utils/HttpUtil';
import { UserNameManager } from '../../utils/GlobalState'

@Entry
@Component
struct WritePage {
  @State shopName: string = '';
  @State location: string = '';
  @State title: string = '';
  @State description: string = '';

  @State selectedImages: string[] = [];
  @State imagePreviews: string[] = [];
  @State isSubmitting: boolean = false;

  // 显式绑定TextInput的值
  @State shopNameInputValue: string = '';
  @State locationInputValue: string = '';
  @State titleInputValue: string = '';
  @State descriptionInputValue: string = '';

  build() {
    Column() {
      Text('美食推荐信息')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 30 })

      // 店名输入
      Column() {
        Text('店名：').fontSize(18)
        TextInput({ placeholder: '请输入店铺名称', text: this.shopNameInputValue })
          .width('100%')
          .height(40)
          .onChange((value: string) => {
            this.shopName = value;
            this.shopNameInputValue = value;
          })
      }.margin({ bottom: 15 })

      // 位置输入
      Column() {
        Text('位置：').fontSize(18)
        TextInput({ placeholder: '请输入详细地址', text: this.locationInputValue })
          .width('100%')
          .height(40)
          .onChange((value: string) => {
            this.location = value;
            this.locationInputValue = value;
          })
      }.margin({ bottom: 15 })

      // 标题输入
      Column() {
        Text('标题：').fontSize(18)
        TextInput({ placeholder: '请输入推荐标题', text: this.titleInputValue })
          .width('100%')
          .height(40)
          .onChange((value: string) => {
            this.title = value;
            this.titleInputValue = value;
          })
      }.margin({ bottom: 15 })

      // 店铺介绍
      Column() {
        Text('店铺介绍：').fontSize(18)
        TextArea({ placeholder: '请描述店铺特色、推荐理由等', text: this.descriptionInputValue })
          .width('100%')
          .height(100)
          .onChange((value: string) => {
            this.description = value;
            this.descriptionInputValue = value;
          })
      }.margin({ bottom: 15 })

      // 图片上传区域
      Column() {
        Text('上传照片：').fontSize(18)

        Grid() {
          ForEach(this.imagePreviews, (preview: string, index) => {
            GridItem() {
              Stack({ alignContent: Alignment.TopEnd }) {
                Image(preview)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)

                Button() {
                  Image($r('app.media.delete'))
                    .width(16)
                    .height(16)
                }
                .width(24)
                .height(24)
                .padding(0)
                .backgroundColor('#00000099')
                .borderRadius(12)
                .onClick(() => this.removeImage(index))
              }
              .width(100)
              .height(100)
            }
          })

          if (this.selectedImages.length < 3) {
            GridItem() {
              Button('+', { type: ButtonType.Normal })
                .width(100)
                .height(100)
                .fontSize(24)
                .backgroundColor('#D3D3D3')
                .border({
                  width: 1,
                  color: '#ccc',
                  style: BorderStyle.Dashed
                })
                .onClick(() => {
                  this.pickImage();
                })
            }
          }
        }
        .columnsTemplate('1fr 1fr 1fr')
        .height('120')

        Text('最多可上传3张图片')
          .fontSize(12)
          .fontColor('#666')
      }.margin({ bottom: 30 })

      Button('提交推荐', { type: ButtonType.Capsule })
        .width('80%')
        .height(45)
        .backgroundColor('#FFA500')
        .fontColor(Color.White)
        .margin({ top: 20 })
        .onClick(() => {
          if (!this.isSubmitting) {
            this.handleSubmit();
          }
        })
        .opacity(this.isSubmitting ? 0.7 : 1)
        .stateStyles({
          disabled: {
            backgroundColor: '#CCCCCC'
          }
        })
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }

  // 删除图片
  private removeImage(index: number) {
    this.selectedImages.splice(index, 1);
    this.imagePreviews.splice(index, 1);
    this.selectedImages = [...this.selectedImages];
    this.imagePreviews = [...this.imagePreviews];
  }

  async pickImage(): Promise<void> {
    try {
      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result: photoAccessHelper.PhotoSelectResult = await photoPicker.select({
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 3 - this.selectedImages.length
      });

      if (result.photoUris && result.photoUris.length > 0) {
        for (const uri of result.photoUris) {
          this.selectedImages.push(uri);
          this.imagePreviews.push(uri);
        }
        this.selectedImages = [...this.selectedImages];
        this.imagePreviews = [...this.imagePreviews];
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`选择图片失败: ${err.code}, ${err.message}`);
      ShowToast('选择图片失败');
    }
  }

  // 将图片转换为Base64
  async imageToBase64(uri: string): Promise<string> {
    try {
      const context = getContext(this) as Context;
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

      // 创建查询谓词
      const predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);

      const fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };

      // 获取匹配的资源
      const fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
        await phAccessHelper.getAssets(fetchOptions);

      const photoAsset: photoAccessHelper.PhotoAsset | undefined = await fetchResult.getFirstObject();

      if (!photoAsset) {
        throw new Error(`未找到URI对应的资源: ${uri}`);
      }

      // 使用Promise封装异步操作
      return new Promise<string>((resolve, reject) => {
        class CustomMediaHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
          onDataPrepared(data: ArrayBuffer) {
            try {
              if (!data || data.byteLength === 0) {
                reject(new Error('接收到的图片数据为空'));
                return;
              }

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
      console.error(`图片转换失败: code=${err.code}, message=${err.message}`);
      throw new Error(`图片处理失败: ${err.message}`);
    }
  }

  // 提交处理函数
  private async handleSubmit() {
    if (this.isSubmitting) return;
    this.isSubmitting = true;

    // 表单验证
    if (!this.shopName.trim()) {
      ShowToast('请输入店铺名称');
      this.isSubmitting = false;
      return;
    }

    if (this.selectedImages.length === 0) {
      ShowToast('请至少上传一张图片');
      this.isSubmitting = false;
      return;
    }

    try {
      // 转换所有图片为Base64
      const base64Images: string[] = [];
      for (const uri of this.selectedImages) {
        try {
          const base64 = await this.imageToBase64(uri);
          base64Images.push(base64);
          ShowToast('正在处理图片...');
        } catch (error) {
          console.error(`图片转换失败: ${uri}`, error);
        }
      }

      if (base64Images.length === 0) {
        ShowToast('图片处理失败，请重试');
        this.isSubmitting = false;
        return;
      }

      interface FormData {
        userId: number
        shopName: string
        shopLocation: string
        description: string
        title: string
        images: string[] // Base64格式图片数组
      }

      const formData: FormData = {
        userId: (await UserNameManager.getUserInformation()).userId,
        shopName: this.shopName,
        shopLocation: this.location,
        description: this.description,
        title: this.title,
        images: base64Images
      };

      // 提交数据到后端
      let httpRequest = http.createHttp()
      const response = await httpRequest.request(
        `${HttpUtil.BASE_URL}/addRecommendation`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(formData)
        }
      )
      console.log('我的提示'+response.result.toString())
      // let result=response.result.toString()
      // if (result.includes('申请提交成功')) {
      //   ShowToast('申请已提交，等待审核中...');
      // }else {
      //   ShowToast('申请提交失败');
      // }
      if (response.responseCode === 200) {
        ShowToast('推荐添加成功');
      } else {
        ShowToast('推荐添加失败');
      }

      this.resetForm();
    } catch (error) {
      console.error('提交过程中出错:', error);
      ShowToast('提交失败');
    } finally {
      this.isSubmitting = false;
    }
  }

  // 重置表单
  private resetForm() {
    // 重置状态变量
    this.shopName = '';
    this.location = '';
    this.title = '';
    this.description = '';

    // 重置输入框值
    this.shopNameInputValue = '';
    this.locationInputValue = '';
    this.titleInputValue = '';
    this.descriptionInputValue = '';

    // 重置图片
    this.selectedImages = [];
    this.imagePreviews = [];
  }
}

export default WritePage;