// FoodImageEntryAbility.ets
import formBindingData from '@ohos.app.form.formBindingData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ShowToast } from '../../utils/ShowToast';
import { util } from '@kit.ArkTS';
import { dataSharePredicates } from '@kit.ArkData';
import { http } from '@kit.NetworkKit';
import { HttpUtil } from '../../utils/HttpUtil';
import { UserNameManager } from '../../utils/GlobalState';
import { router } from '@kit.ArkUI';

interface FormData {
  shopId: number,
  name: string,
  price: number,
  description: string,
  imagePath: string
};

@CustomDialog
@Component
export struct FoodImageDialog {
  controller: CustomDialogController;
  // 菜品基础信息
  @State foodName: string = '';
  @State foodPrice: number | null = null;
  @State foodDescription: string = '';
  @Prop shopId: number;

  // 显式绑定值（用于双向绑定）
  @State foodNameInput: string = '';
  @State foodPriceInput: string = '';
  @State foodDescInput: string = '';

  // 图片管理
  //@State foodImagePreviews: string[] = [];

  @State isSubmitting: boolean = false;
  @State selectedImage: string = ''; // 存储选中的图片路径
  @State isImageSelected: boolean = false; // 标记是否已选择图片
  @State imagePreview: string = 'app.media.software_icon';//图片路径地址
  @State imageBase64: string = ''; // 存储Base64格式的图片数据

  build() {
    Stack(){
      Column() {
        Text('添加菜品信息')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 30 })

        // 菜品名称输入
        Column() {
          Text('菜品名称：').fontSize(18)
          TextInput({
            placeholder: '请输入菜品名称',
            text: this.foodNameInput
          })
            .width('100%')
            .height(40)
            .onChange((value: string) => {
              this.foodName = value;
              this.foodNameInput = value;
            })
        }.margin({ bottom: 15 })

        // 菜品价格输入（带格式验证）
        Column() {
          Text('价格（元）：').fontSize(18)
          TextInput({
            placeholder: '请输入数字',
            text: this.foodPriceInput,
          })
            .type(InputType.Number)
            .width('100%')
            .height(40)
            .onChange((value: string) => {
              const num = parseFloat(value);
              this.foodPrice = isNaN(num) ? null : num;
              this.foodPriceInput = value;
            })
        }.margin({ bottom: 15 })

        // 菜品描述
        Column() {
          Text('菜品描述：').fontSize(18)
          TextArea({
            placeholder: '请描述菜品特色（50字内）',
            text: this.foodDescInput
          })
            .width('100%')
            .height(80)
            .onChange((value: string) => {
              this.foodDescription = value;
              this.foodDescInput = value;
            })
        }.margin({ bottom: 15 })

        // 菜品图片上传
        this.buildImageUploader()

        // 提交按钮
        Button('提交菜品', { type: ButtonType.Capsule })
          .width('80%')
          .height(45)
          .backgroundColor('#FFA500')
          .fontColor(Color.White)
          .margin({ top: 20 })
          .onClick(() => {
            if(!this.isSubmitting){
              this.handleSubmit();
            }
          })
          .opacity(this.isSubmitting ? 0.7 : 1)
        }
        .padding(20)
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')

      Image($r('app.media.close'))
        .width(40)
        .height(40)
        .position({ x: '80%', y: '4%' })
        .onClick(() => this.controller.close())
        .zIndex(999)
    }
    .width("100%")
    .height("100%")
  }

  // 图片上传组件
  @Builder
  buildImageUploader() {
    Column() {
      Text('上传照片：').fontSize(18)

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
    }
  }

  async pickImage(): Promise<void> {
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

  // 提交处理
  private async handleSubmit() {
    if (this.isSubmitting) return;
    this.isSubmitting = true;

    // 表单验证
    if (!this.foodName.trim()) {
      ShowToast('菜品名称不能为空');
      this.isSubmitting = false;
      return;
    }
    if (this.foodPrice == null || this.foodPrice <= 0) {
      ShowToast('请输入有效价格');
      this.isSubmitting = false;
      return;
    }
    if (!this.foodDescription.trim()) {
      ShowToast('请填写菜品描述');
      this.isSubmitting = false;
      return;
    }
    if (this.selectedImage === '') {
      ShowToast('请选择一张菜品图片上传');
      this.isSubmitting = false;
      return;
    }

    try {
      // 转换图片为Base64
      const base64String = await this.imageToBase64(this.selectedImage);
      this.imageBase64 = base64String;

      // 构建请求数据
      const formData : FormData= {
        shopId: this.shopId,
        name: this.foodName,
        price: this.foodPrice,
        description: this.foodDescription,
        imagePath: base64String
      };

      // 提交请求
      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        `${HttpUtil.BASE_URL}/addFoodImage`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(formData)
        }
      );

      if (response.responseCode === 200) {
        ShowToast('菜品添加成功');
        this.resetForm();
      } else {
        ShowToast('提交失败，请重试');
      }
    } catch (error) {
      ShowToast('系统错误: ' + (error as Error).message);
    } finally {
      this.isSubmitting = false;
    }
  }

  // 图片转Base64
  private async imageToBase64(uri: string): Promise<string> {
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
    }finally {
      this.isSubmitting = false;
    }
  }

  // 重置表单
  private resetForm() {
    this.foodName = '';
    this.foodPrice = null;
    this.foodDescription = '';
    this.foodNameInput = '';
    this.foodPriceInput = '';
    this.foodDescInput = '';
    this.selectedImage = '';
    this.isImageSelected = false; //未选中相片
  }
}
