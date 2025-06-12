//增加个清空申请表？

import { Application } from '../model/Application'
import { router } from '@kit.ArkUI';
import { HttpUtil } from '../utils/HttpUtil';
import { http } from '@kit.NetworkKit';
import { ShowToast } from '../utils/ShowToast';
import { ImageUtil } from '../utils/ImageUtil'; // 导入图片工具类
import {UserNameManager, userNameStorage, USER_NAME_KEY} from './../utils/GlobalState'

interface StatusColorMap {
  pending: string;
  approved: string;
  rejected: string;
}

interface AppliedResult {
  applicationId: number;
  status: string;
}

interface RejectApplication{
  applicationId: number;
  rejectionReason: string;
}

interface AddShop{
  ownerName: string
  shopName: string
  location: string
  description: string
  imagePath: string
  category: string
  openTime: string
  closeTime: string
}

@Entry
@Component
struct Manage {
  //用于操作全局的用户名
  @StorageLink(USER_NAME_KEY) username: string = '';
  //处理拒绝操作的变量
  @State isRejectionDialogVisible: boolean = false;
  @State rejectionReason: string = '';
  // 新增选中ID,用于在打开拒绝弹窗时能获取到正确的店铺id
  @State selectedApplicationId: number | null = null;

  private listScroller: Scroller = new Scroller();

  @State private applications: Application[] = []//存储申请
  @State placeholderImage: Resource = $r('app.media.shop_placeholder'); // 占位图

  // 修改拒绝按钮点击处理
  onRejectClick(applicationId: number) {
    this.selectedApplicationId = applicationId;
    this.isRejectionDialogVisible = true;
    this.rejectionReason = '';
  }

  // 状态颜色映射
  statusColorMap: StatusColorMap = {
    pending: '#FFA500',   // 橙色
    approved: '#008000',  // 绿色
    rejected: '#FF0000'   // 红色
  };

  getStatusColor(status: string): string {
    switch (status) {
      case 'pending': return '#FFA500';
      case 'approved': return '#008000';
      case 'rejected': return '#FF0000';
      default: return '#666';
    }
  }

  build() {
    Stack() {
      Column() {
        // 标题栏
        Row() {
          Image($r('app.media.arrow_back'))
            .width(26)
            .margin({ left: 40 })
            .onClick(() => {
              router.back()
            })

          Text('店铺申请审批')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 20 })
        }
        .width('100%')
        .height(60)
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 2, color: '#1A000000' })

        // 申请列表
        List({ space: 10, scroller: this.listScroller }) {
          ForEach(this.applications, (item: Application) => {
            ListItem() {
              Column(){
                Row() {
                  // 左侧店铺图片
                  Column() {
                    // 显示店铺图片
                    if (item.imagePath) {
                      Image(ImageUtil.getFullImageUrl(item.imagePath))
                        .width(100)
                        .height(100)
                        .objectFit(ImageFit.Cover)
                        .borderRadius(8)
                        .onError(() => {
                          console.error('图片加载失败:', item.imagePath);
                        })
                    } else {
                      Image(this.placeholderImage)
                        .width(100)
                        .height(100)
                        .objectFit(ImageFit.Cover)
                        .borderRadius(8)
                    }
                  }
                  .margin({ right: 14 })

                  // 中间店铺信息
                  Column() {
                    // 店铺名和状态行

                    Text(`店铺名：${item.shopName}`)
                      .fontSize(14)
                      .fontColor('#333')
                      .margin({ bottom: 8 })
                      .width('100%')

                    Text(`申请人：${item.userName}`)
                      .fontSize(14)
                      .fontColor('#666')
                      .margin({ bottom: 4 })
                      .width('100%')

                    Text(`位置：${item.shopLocation}`)
                      .fontSize(14)
                      .fontColor('#666')
                      .margin({ bottom: 4 })
                      .width('100%')

                    Text(`分类：${item.shopCategory}`)
                      .fontSize(14)
                      .fontColor('#666')
                      .margin({ bottom: 4 })
                      .width('100%')

                    Text(`营业时间：${item.openTime} - ${item.closeTime}`)
                      .fontSize(14)
                      .fontColor('#666')
                      .width('100%')
                  }
                  .width('50%')

                  // 右侧操作按钮
                  Column() {
                    Text(item.status.toUpperCase())
                      .fontSize(14)
                      .fontColor(this.getStatusColor(item.status))
                      .margin({ bottom: 8 })
                    if (item.status === 'pending') {
                      Button('通过')
                        .type(ButtonType.Normal)
                        .width(60)
                        .height(32)
                        .backgroundColor('#007DFF')
                        .margin({ bottom: 8 })
                        .borderRadius('30')
                        .onClick(() => this.handleApplication(item.applicationId, 'approved'))

                      Button('拒绝')
                        .type(ButtonType.Normal)
                        .width(60)
                        .height(32)
                        .backgroundColor('#FF0000')
                        .borderRadius('30')
                        .onClick(() => this.onRejectClick(item.applicationId))
                    }
                  }
                  .alignItems(HorizontalAlign.End)
                }
                // 底部申请时间和描述
                Column() {
                  Text(`申请时间：${item.createdAt}`)
                    .fontSize(12)
                    .fontColor('#999')
                    .margin({ bottom: 8 })

                  if (item.shopDescription) {
                    Text(`店铺描述：${item.shopDescription}`)
                      .fontSize(12)
                      .fontColor('#666')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
                .width('100%')
                .margin({ top: 8 })
              }
            }
            .margin({ left: 16, right: 16, top: 8, bottom: 8 })
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({ radius: 2, color: '#1A000000' })
          })
        }
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
        //拒绝窗口
        if (this.isRejectionDialogVisible) {
          Column() {
            // 半透明遮罩
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor('#000000')
              .opacity(0.5)
              .onClick(() => {
                this.isRejectionDialogVisible = false;
              })
            // 弹窗内容
            Column() {
              Text('请输入拒绝理由')
                .fontSize(24)
                .margin({ bottom: 20 })

              TextInput({ placeholder: '请输入详细理由...' })
                .width('90%')
                .height(120)
                .backgroundColor('#FFF')
                .onChange(v => this.rejectionReason = v)

              Row() {
                Button('取消')
                  .onClick(() => this.isRejectionDialogVisible = false)

                Button('确认拒绝')
                  .onClick(() => {
                    if (!this.rejectionReason.trim()) {
                      ShowToast('请填写拒绝理由');
                      return;
                    }
                    this.handleApplication(this.selectedApplicationId!, 'rejected');
                    this.isRejectionDialogVisible = false;
                  })
              }
              .justifyContent(FlexAlign.SpaceEvenly)
              .width('100%')
            }
            .width('80%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .position({ x: '10%' })
            .margin({ top: '20%' })
          }
          .position({ x: 0, y: 0 })
          .width('100%')
          .height('100%')
          .zIndex(999)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
  }

  aboutToAppear(): void {
    this.loadApplication();
  }

  //加载申请列表
  async loadApplication() {
    try{
      const result = await HttpUtil.getApplication(1,100);
      this.applications = result.list;
    }catch (error){

    }
  }

  // 申请情况操作,id为店铺id
  async handleApplication(id: number, action: 'approved' | 'rejected'): Promise<void> {
    //通过或拒绝都需要更新application表中的status
    let result: AppliedResult = {
      applicationId: id,
      status: action
    }
    let httpRequest = http.createHttp()
    const response = await httpRequest.request(
      `${HttpUtil.BASE_URL}/appliedResult`,
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(result)
      }
    )

    //通过的话需要改变user表,将用户身份从顾客改为商家
    //将店铺数据添加到shop表中。
    if(action === 'approved'){
      // 将数据添加到shop表中
      // 从已加载的申请列表中查找对应的申请
      const application = this.applications.find(app => app.applicationId === id);

      if (application) {
        // 构建 AddShop 对象
        const addShopData: AddShop = {
          ownerName: application.userName,       // 店主姓名
          shopName: application.shopName,        // 店铺名称
          location: application.shopLocation,    // 店铺位置
          description: application.shopDescription || '', // 店铺描述
          imagePath: application.imagePath || '', // 店铺图片路径
          category: application.shopCategory,    // 店铺分类
          openTime: application.openTime,        // 营业开始时间
          closeTime: application.closeTime       // 营业结束时间
        };

        // 发送添加店铺请求
        try {
          const addShopRequest = http.createHttp();
          const addShopResponse = await addShopRequest.request(
            `${HttpUtil.BASE_URL}/addShop`,
            {
              method: http.RequestMethod.POST,
              header: {
                'Content-Type': 'application/json'
              },
              extraData: JSON.stringify(addShopData)
            }
          );

          if (addShopResponse.responseCode === 200) {
            ShowToast('店铺添加成功');
          } else {
            ShowToast('店铺添加失败');
          }
        } catch (error) {
          console.error('添加店铺错误:', error);
          ShowToast('添加店铺时出错');
        }
      }

      //更新身份为商家
      let httpRequest = http.createHttp()
      const response = await httpRequest.request(
        `${HttpUtil.BASE_URL}/approveApplication`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({
            userName: UserNameManager.getName()
          })
        }
      )
    }else { //拒绝的话需要填写拒绝理由，并将理由更新到application表中
      let rejectApplication: RejectApplication = {
        applicationId: id,
        rejectionReason: this.rejectionReason
      }
      let httpRequest = http.createHttp()
      const response = await httpRequest.request(
        `${HttpUtil.BASE_URL}/rejectApplication`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(rejectApplication)
        }
      )
    }
    //刷新页面
    await this.loadApplication();
  }
}