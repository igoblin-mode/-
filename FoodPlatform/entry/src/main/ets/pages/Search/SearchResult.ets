
import SearchShop from './SearchShop'
import SearchRecommend from './SearchRecommend'
import SearchUser from './SearchUser'
import { router } from '@kit.ArkUI'

const RECENT_SEARCH_LIST: string = 'recent_search_list'

interface RouteParams {
  searchTip?: string // 可能不纯在
}

// SearchResultPage.ets
@Entry
@Component
struct SearchResultPage {
  @State searchText: string = '火锅'
  @State searchKeyword: string = '火锅' // 实际用于搜索的关键词
  @State selectedIndex: number = 0
  @StorageLink(RECENT_SEARCH_LIST) recentSearchList: string[] = [] // 共享最近搜索记录

  private tabs: string[] = ['店铺', '推荐', '用户']

  // 页面显示时获取参数
  aboutToAppear() {
    const params = router.getParams() as RouteParams
    if (params && params.searchTip) {
      this.searchText = params.searchTip
      this.searchKeyword = params.searchTip // 初始化搜索关键词
    }
  }

  // 执行搜索的方法
  performSearch() {
    this.searchKeyword = this.searchText // 更新实际搜索关键词
  }

  // 搜索处理函数（与 SearchPage 中的功能一致）
  searchTipHandler(value: string) {
    if (!value) return;

    // 更新搜索文本
    this.searchText = value;

    // 更新最近搜索记录
    const index = this.recentSearchList.findIndex(item => item === value)
    if (index !== -1) {
      this.recentSearchList.splice(index, 1)
    }
    this.recentSearchList.unshift(value)
  }

  build() {
    Column() {
      // 顶部导航栏
      Row({ space: 8 }) {
        Image($r('app.media.arrow_back'))
          .width(26)
          .margin({ left: 10})
          .onClick(() => {
            router.back()
          })
        TextInput({ text: this.searchText, placeholder: '输入你想搜索的内容' })
          .placeholderFont({ size: 16 })
          .height(40)
          .layoutWeight(1)
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.searchText = value // 只更新输入框内容，不触发搜索
          })
          .onSubmit(() => {
            this.performSearch() // 回车键触发搜索
          })
        Text('搜索')
          .fontWeight(600)
          .fontColor(Color.Black)
          .margin({ right: 20, top: 5 })
          .onClick(() => {
            this.performSearch() // 按钮点击触发搜索
          })
      }
      .padding({ left: 12, right: 12, top: 8 })
      .margin({ bottom: 12 })

      Tabs({ barPosition: BarPosition.Start, index: this.selectedIndex }) {
        ForEach(this.tabs, (item: string, index) => {
          TabContent() {
            this.SearchResultList(index) // 根据索引显示不同内容
          }
          .tabBar(item)
        })
      }
      .onChange((index: number) => {
        this.selectedIndex = index
      })
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(40)
      .margin({ bottom: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f1f3f5")
  }


  // 搜索结果列表组件
  @Builder SearchResultList(index: number) {
    Column() {
      if (index === 0) { // 店铺结果
        SearchShop({
          searchMessage: this.searchKeyword // 传递实际搜索关键词
        })
      } else if (index === 1) { // 推荐结果
        SearchRecommend({
          searchMessage: this.searchKeyword
        })
      } else { // 用户结果
        SearchUser({
          searchMessage: this.searchKeyword
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}