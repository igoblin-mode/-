// GlobalState.ets

import { User } from '../model/User';
import { HttpUtil } from '../utils/HttpUtil'

// 定义接口明确对象类型
interface UserNameStorage {
  link: SubscribedAbstractProperty<string>; //双向绑定属性（UI能够自动更新）
  prop: SubscribedAbstractProperty<string>; //单向绑定属性（只读）
}

// 定义AppStorage的键常量（防止拼写错误）
export const USER_NAME_KEY = 'globalUserName';

// 用户名操作接口封装
export class UserNameManager {
  // 初始化用户名存储
  static initialize(defaultName: string = '') {
    // 初始化AppStorage值
    if (!AppStorage.has(USER_NAME_KEY)) {
      AppStorage.setOrCreate(USER_NAME_KEY, defaultName);
    }
  }

  // 获取用户名,不是获取的昵称！！！
  static getName(): string {
    const name = AppStorage.get<string>(USER_NAME_KEY);
    console.info("我的提示getName"+name)
    return typeof name === 'string' ? name : '';
  }

  // 设置用户名（带空值过滤）
  static setName(newName: string): void {
    if (newName.trim().length > 0) {
      AppStorage.set(USER_NAME_KEY, newName.trim());
    }
  }

  static async getUserInformation(): Promise<User> {
    const userName = UserNameManager.getName();
    console.info("我的提示qq"+userName)
    try {
      const user = await HttpUtil.getUserInformation(userName);
      console.info("我的提示22222"+user.userName)
      return user;
    } catch (error) {
      console.error('getUserInformation: Error checking business status:', error);
      return {
        userId: -1,
        userName: '',
        password: '',
        nickName: '',
        avatar: '',
        role: '',
        createdAt: '',
        businessStatus: ''
      } as User;
    }
  }
}

// 显式声明类型并初始化
export const userNameStorage: UserNameStorage = {
  // 双向绑定装饰器
  link: AppStorage.link(USER_NAME_KEY),

  // 单向绑定装饰器
  prop: AppStorage.prop(USER_NAME_KEY)
};


