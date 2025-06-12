// common/utils/toastUtil.ets
import promptAction from '@ohos.promptAction';

/**
 * 显示Toast提示
 * @param message 提示消息
 * @param duration 显示时长（毫秒），默认2000ms
 */
export const ShowToast = (message: string, duration: number = 2000) => {
  promptAction.showToast({
    message: message,
    duration: duration,
    textColor: Color.Red,
    backgroundColor: '#FFFFFF' // 深灰色背景
  });
};