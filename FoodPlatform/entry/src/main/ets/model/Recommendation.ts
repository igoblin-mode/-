// 定义数据模型
export interface Recommendation {
  recommendationId: number;
  nickName: string;
  avatar: string;
  shopName: string;
  title: string;
  shopLocation: string;
  description: string;
  imagePaths: string[];
}

export interface RecommendationImage {
  id: number;
  recommendationId: number;
  imagePath: string;
}

//推荐的首页展示所需数据，不是详细页的所需数据
export interface Note {
  id: number; // 推荐id
  title: string;
  content: string;
  author: Author;
  image: string; // 存储图片URL
}

export interface Author {
  name: string;
  avatar: string;
}

export interface MyRecommendation {
  recommendationId: number;
  shopId: number;
  shopName: string;
  title: string;
  shopLocation: string;
  description: string;
  imagePath: string;
}