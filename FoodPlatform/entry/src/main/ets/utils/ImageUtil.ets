// utils/ImageUtil.ts

import { HttpUtil } from './HttpUtil';
import { ErrorEvent } from '@kit.ArkTS';

export class ImageUtil {
  // 获取完整图片URL
  static getFullImageUrl(relativePath: string): string {
    return HttpUtil.BASE_URL + relativePath;
  }

  // 获取图片占位符
  static getPlaceholder(): string {
    return '';
  }

  // 处理图片错误
  static handleImageError(event: ErrorEvent ): void {
    console.error('图片加载失败:', event);
    // 这里可以添加错误处理逻辑，如替换为占位图
  }
}