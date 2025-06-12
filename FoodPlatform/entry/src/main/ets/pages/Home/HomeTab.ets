@Component
struct HomeTab {
  @Link currentSortType: string
  @Link selectedCategory: number
  @Link showCategoryOptions: boolean

  build() {
    Column() {
      Row({ space: 25 }) {
        // 评分排序、随机推荐按钮
        Column() {
          Text('评分排序')
            .fontColor(this.currentSortType === 'rating' ? '#000' : '#656565')
          if (this.currentSortType === 'rating') {
            Row().width(15).height(2).backgroundColor('#000')
          }
        }
        .onClick(() => {
          this.currentSortType = 'rating'
          this.showCategoryOptions = false
        })

        Text('随机推荐')
          .fontColor(this.currentSortType === 'random' ? '#000' : '#656565')
          .onClick(() => {
            this.currentSortType = 'random'
            this.showCategoryOptions = false
          })

        // 主营分类按钮
        Column() {
          Text('主营分类')
            .fontColor(this.currentSortType === 'category' ? '#000' : '#656565')
            .onClick(() => {
              this.currentSortType = 'category'
              this.showCategoryOptions = !this.showCategoryOptions
            })
        }
      }
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .margin({ top: 18 })
  }
}

export default HomeTab

