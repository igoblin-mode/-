import Home from './Home/Home'
import RecommendPage from './Recommend/RecommendPage'
import { font, router } from '@kit.ArkUI'
import WritePage from './WriteRecommend/WritePage'
import UserPage from './UserCenter/UserPage'

interface MenuItemType {
  icon: string,
  text: string
}

interface ParamsType {
  index: number
}

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0
  @State menus: MenuItemType[] = [
    { icon: 'home', text: '首页' },
    { icon: 'recommend', text: '推荐' },
    { icon: 'write_recommend', text: '写推荐' },
    { icon: 'mine', text: '我的' },
  ]

  aboutToAppear(): void {
    // 页面加载就注册iconfont
    font.registerFont({
      familyName: 'sysFont',
      familySrc: '/utils/font/iconfont.ttf'
    })

    // 功能直达进入页面
    this.currentIndex = (router.getParams() as ParamsType)?.index || 0
    // 请求案例
    // IndexApi.getList().then((res: AxiosResponse) => {
    //   console.log('list数据', JSON.stringify(res))
    // }).catch((err: AxiosError) => {
    //   console.log('err', err)
    // })
  }

  // 菜单样式
  @Builder
  TabBarBuilder(item: MenuItemType, index: number) {
    Column({ space: 4 }) {
      Image($r(`app.media.${item.icon}`))
        .width(25)
        .fillColor(index === this.currentIndex ? '#ca141d' : '#808182')
      Text(item.text)
        .fontSize(12)
        .fontColor(index === this.currentIndex ? '#ca141d' : '#808182')
    }
  }

  // 加载菜单对应的组件
  @Builder
  TabEachBuilder(index: number) {
    if (index === 0) {
      Home()
    } else if (index === 1) {
      RecommendPage()
    } else if (index === 2) {
      WritePage()
    } else if (index === 3) {
      UserPage()
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        ForEach(this.menus, (item: MenuItemType, index: number) => {
          TabContent() {
            this.TabEachBuilder(index)
          }
          .tabBar(this.TabBarBuilder(item, index))
        })
      }
      .animationDuration(0)
      .barBackgroundColor('#f1f3f5')
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .divider({
        strokeWidth: 1,
        color: '#ffeaeaea'
      })
    }
    .height('100%')
  }
}
