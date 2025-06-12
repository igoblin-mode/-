
import { router } from '@kit.ArkUI'
// 存储用户最近搜索记录
const RECENT_SEARCH_LIST: string = 'recent_search_list'
// 当前查找提示
const SEARCH_TIP: string = 'search_tip'

interface RouterParams {
  searchTip?: string
}

@Entry
@Component
struct SearchPage {
  @State searchValue: string = ''
  @State tipList: string[] = []
  // 最近搜索
  @StorageLink(RECENT_SEARCH_LIST) recentSearchList: string[] = []
  @StorageLink(SEARCH_TIP) searchTip: string = ''
  @State routerParams: RouterParams = {}

  //猜你想搜
  aboutToAppear(): void {
    this.tipList = [
      '炒菜盖饭',
      '甜品饮品',
      '米粉面条',
      '快餐小吃',
      '789',
      '超赞'
    ]
  }

  onPageShow(): void {
    this.searchValue = ''
    const params = router.getParams() as RouterParams
    if (params) {
      this.routerParams = params
      this.searchValue = this.routerParams?.searchTip || ''
    }
  }

  // 搜索处理函数
  searchTipHandler(value: string) {
    router.pushUrl({
      url: 'pages/Search/SearchResult',
      params: { searchTip: value }
    })
    const index = this.recentSearchList.findIndex(item => item === value)
    if (index !== -1) { // 数据存在需要提到第一个
      this.recentSearchList.splice(index, 1)
    }
    this.recentSearchList.unshift(value)
  }

  @Builder
  searchTipButtonBuilder(item: string) {
    Button(item)
      .backgroundColor('#ffe3e3e3')
      .controlSize(ControlSize.SMALL)
      .fontColor("#666")
      .margin({ right: 10, top: 10 })
      .onClick(() => {
        // 快捷点击搜索点击处理
        this.searchTipHandler(item)
      })
  }

  build() {
    Column() {
      // top导航/搜索模块
      Row() {
        Image($r('app.media.arrow_back'))
          .width(26)
          .margin({ left: 20})
          .onClick(() => {
            router.back()
          })

        Search({
          value: this.searchValue,
          placeholder: this.searchTip || '请输入'
        })
          .backgroundColor('#fff')
          .layoutWeight(1)

          .margin({
            left: 15,
            right: 15,
            top: 10
          })
          .onChange((value: string) => {
            this.searchValue = value
          })

        Text('搜索')
          .fontWeight(600)
          .fontColor(Color.Black)
          .margin({right :20,top :5})
          .onClick(() => {
            const value: string = this.searchValue || this.searchTip
            this.searchTipHandler(value)
          })
      }


      Scroll() {
        Column() {
          // 最近搜索
          if (this.recentSearchList.length > 0) Column() {
            Row() {
              Text('最近搜索')
                .fontWeight(500)
              Blank()
              Image($r('app.media.delete'))
                .width(22)
                .onClick(() => {
                  this.recentSearchList = []
                })
            }
            .width('100%')

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.recentSearchList, (item: string) => {
                this.searchTipButtonBuilder(item)
              })
            }.width('100%')
            .margin({
              top: 10
            })
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 15 })

          // 猜你想搜
          Column() {
            Row() {
              Text('猜你想搜')
                .fontWeight(500)
            }
            .width('100%')

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.tipList, (item: string) => {
                this.searchTipButtonBuilder(item)
              })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ left: 15, right: 15, top: 15 })

        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f1f3f5")
  }
}