//分页响应类型
export interface PageResult<T> {
  total: number;
  list: T[]
}

//申请实体类型
export interface Application{
  applicationId: number;
  userName: string;
  shopName: string;
  shopLocation: string;
  shopDescription: string;
  shopCategory: string;
  openTime: string;
  closeTime: string;
  status: string;
  createdAt: string;
  reviewedAt: string;
  rejectionReason: string;
  imagePath: string
}

//网络错误类型
export interface HttpError{
  code: number;
  message: string
}
