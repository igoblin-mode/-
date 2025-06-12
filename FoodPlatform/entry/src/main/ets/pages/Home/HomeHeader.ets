import { router } from '@kit.ArkUI'
import { SEARCH_TIP } from '../../utils/Constant';

@Component
struct HomeHeader {
  @State tipList: string[] = []
  @State findTipsCount: number = 0
  private timer: number = -1

  findTipsCountChange(): void {
    clearInterval(this.timer)
    this.timer = setInterval(() => {
      if (this.findTipsCount >= this.tipList.length - 1) {
        this.findTipsCount = 0
      } else {
        this.findTipsCount++
      }
    }, 3000)
  }

  // 组件销毁
  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Row({ space: 10 }) {
      Image($r('app.media.logo_letter'))
        .width(80)
      // 搜索框
      Row() {
        Image($r('app.media.search'))
          .width(22)
          .fillColor('#5c5c5d')
        Text(this.tipList[this.findTipsCount])
          .backgroundColor(Color.Transparent)
          .fontColor('#666')
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .maxLines(1)
          .layoutWeight(1)
      }
      .backgroundColor('#e5e7e9')
      .borderRadius(25)
      .layoutWeight(1)
      .padding(10)
      .onClick(() => {
        AppStorage.setOrCreate(SEARCH_TIP, this.tipList[this.findTipsCount])
        router.pushUrl({
          url: 'pages/Search/SearchPage'
        })
      })

      Image($r('app.media.comments'))
        .width(28)
    }
    .width('100%')
    .height(58)
    .backgroundColor('#f1f3f5')
    .padding({
      left: 10,
      right: 10
    })
  }
}

export default HomeHeader