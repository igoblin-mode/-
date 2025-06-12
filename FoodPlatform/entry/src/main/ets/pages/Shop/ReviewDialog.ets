import { UserNameManager } from '../../utils/GlobalState';
import { ShowToast } from '../../utils/ShowToast';
import { http } from '@kit.NetworkKit';
import { HttpUtil } from '../../utils/HttpUtil';

interface AddReviewData {
  userId: number;
  shopId: number;
  content: string;
  rating: number;
}

@CustomDialog
@Component
export  struct ReviewInputDialog {
  @State rating: number = 0;
  @State comment: string = '';
  @Prop shopId: number;
  controller: CustomDialogController;

  build() {
    Column() {
      // 评分区域
      Text('请评分:')
        .fontSize(18)
        .margin({ top: 20 })

      // 星星评分组件
      Row() {
        ForEach(Array.from({ length: 5 }), (item: undefined, index) => {
          Image(index < this.rating ? $r('app.media.star_filled') : $r('app.media.star'))
            .width(30)
            .height(30)
            .margin(5)
            .onClick(() => {
              this.rating = index + 1;
            })
        })
      }
      .margin({ top: 10, bottom: 20 })

      // 评论输入框
      TextArea({placeholder: '请输入评论' ,text: this.comment })
        .height(150)
        .width('90%')
        .margin({ bottom: 10 })
        .onChange((value: string) => {
          this.comment = value;
        })

      // 提交按钮
      Button('提交评论')
        .width('90%')
        .height(40)
        .backgroundColor('#FF6A00')
        .fontColor(Color.White)
        .margin({ bottom: 20 })
        .onClick(() => {
          this.addReview();
          this.controller.close();
        })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Center)
  }

  // 添加评论
  async addReview() {
    if (this.rating === 0) {
      ShowToast('请选择评分');
      return;
    }

    if (this.comment.trim().length === 0) {
      ShowToast('请输入评论内容');
      return;
    }

    // 创建评论对象
    const review: AddReviewData = {
      userId: (await UserNameManager.getUserInformation()).userId,
      shopId: this.shopId,
      rating: this.rating,
      content: this.comment,
    };
    try{
      const addReviewRequest = http.createHttp();
      const addReviewResponse = await addReviewRequest.request(
        `${HttpUtil.BASE_URL}/addReview`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(review)
        }
      );
      if(addReviewResponse.responseCode === 200){
        ShowToast('评论添加成功')
      }else{
        ShowToast('评论添加失败')
      }
    }catch (error){
      console.log('添加评论出错'+error);
      ShowToast('添加评论出错')
    }
  }
}