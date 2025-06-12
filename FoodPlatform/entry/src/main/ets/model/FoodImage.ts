// 基础图片接口
export interface Image {
  imageId: number;
  fileName: string;
  imagePath: string;
  uploadTime: string;
}

// 美食图片含美食基本信息接口
export interface FoodImage extends Image {
  shopId: number;
  name: string;
  price: number;
  description: string;
}