// 分类的下拉框
@Component
struct CategoryDropdown {
  @Link showDropdown: boolean
  @Link selectedCategory: number

  build() {
    if (this.showDropdown) {
      Stack() {
        // 半透明遮罩
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#000000')
          .opacity(0.3)
          .onClick(() => this.showDropdown = false)

        // 下拉框内容
        Column() {
          ForEach(['甜品饮品', '米粉面条', '炒菜盖饭', '快餐小吃'], (item: string, index: number) => {
            Text(`${item}`)
              .fontColor(this.selectedCategory === index ? '#000' : '#656565')
              .width('80%')
              .padding(12)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .margin({ top: 4 })
              .onClick(() => {
                this.selectedCategory = index
                this.showDropdown = false
              })
          })
        }
        .width('90%')
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 6, color: '#1A000000' })
        .position({ x: '5%', y: '10%' }) // 定位在HomeTab下方
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
      .zIndex(100) // 确保显示在最上层
    }
  }
}

export default CategoryDropdown