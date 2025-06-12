
//店铺实体类型
export interface Shop{
  shopId: number;
  ownerName: string;
  shopName: string;
  location: string;
  description: string;
  imagePath: string;
  category: string;
  openTime: string;
  closeTime: string;
  avgRating: number;
}
