import HomeHeader from './HomeHeader'
import HomeBody from './HomeBody'
import HomeTab from './HomeTab'
import CategoryDropdown from './CategoryDropdown'

@Component
struct Home {
  scroller: Scroller = new Scroller()
  @State message: string = 'Hello World';
  // 是否展示回到顶部按钮
  @State isShowGoTopButton: boolean = false

  @State sortType: 'rating' | 'random' | 'category' = 'rating' //当前排序方式
  @State currentSortType: string = '未选择'
  @State selectedCategory: number = 0
  @State showCategoryOptions: boolean = false

  build() {
    Column() {
      // 头部
      HomeHeader()

      // 内容主题
      Scroll(this.scroller) {
        Column() {
          // 传递状态引用
          HomeTab({
            currentSortType: $currentSortType,
            selectedCategory: $selectedCategory,
            showCategoryOptions: $showCategoryOptions
          })

          // 传递状态值
          HomeBody({
            currentSortType: this.currentSortType,
            selectedCategory: this.selectedCategory
          })
            .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 15 })
      }
      .width('100%')
      .layoutWeight(1)
      .onWillScroll(() => {
        const scrollYOffset = this.scroller.currentOffset().yOffset
        this.isShowGoTopButton = scrollYOffset > 200 ? true : false
      })

      CategoryDropdown({
        showDropdown: $showCategoryOptions,
        selectedCategory: $selectedCategory
      })

      if (this.isShowGoTopButton) Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r("app.media.arrow_backtotop"))
          .width(20)
          .fillColor('#666')
      }
      .width(35)
      .height(35)
      .backgroundColor('#fff')
      .shadow({
        radius: 3,
        color: '#666',
        offsetX: 2,
        offsetY: 2
      })
      .position({
        bottom: 10,
        right: 10
      })
      .onClick(() => {
        this.scroller.scrollEdge(Edge.Top)
      })
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 180, // 渐变角度，设置为180，即为从上往下渐变
      colors: [['#fefefe', 0], ['#f2f4f5', 1]]
    })

  }
}

export default Home