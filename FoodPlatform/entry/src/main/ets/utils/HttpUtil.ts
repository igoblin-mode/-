import {http} from '@kit.NetworkKit'
import {Application, PageResult, HttpError} from '../model/Application'
import {Shop} from '../model/Shop'
import {User} from '../model/User'
import { MyRecommendation, Recommendation } from '../model/Recommendation';
import { List } from '@kit.ArkTS';
import { FoodImage } from '../model/FoodImage';
import { Review } from '../model/Review';
import { MyReview } from '../model/MyReview';

const NETWORK_TIMEOUT = 15000;

export class HttpUtil {
  static getApplication(page: number, size: number):Promise<PageResult<Application>> {
    return this.request<PageResult<Application>>(
      `/getApplication?pageNum=${page}&pageSize=${size}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data=>data);
  }

  static getShop(page: number, size: number):Promise<PageResult<Shop>> {
    return this.request<PageResult<Shop>>(
      `/getShop?pageNum=${page}&pageSize=${size}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data=>data);
  }

  static getMyShop(ownerName: string):Promise<Shop[]> {
    return this.request<Shop[]>(
      `/getMyShop?ownerName=${ownerName}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data=>data);
  }

  //获取所有的推荐名单
  static getRandomRecommendation(limit: number = 30): Promise<List<Recommendation>> {
    return this.request<List<Recommendation>>(
      `/getRandomRecommendation?limit=${limit}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data => data);
  }

  //根据id获取到推荐
  static getRecommendationById(recommendationId: number): Promise<Recommendation> {
    return this.request<Recommendation>(
      `/getRecommendationById?recommendationId=${recommendationId}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data => data);
  }

  static getShopByCategory(category: string): Promise<Shop[]> {
    // 对中文参数进行URL编码
    const encodedKeyword = encodeURIComponent(category);
    return this.request<Shop[]>(
      `/getShopByCategory?category=${encodedKeyword}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data => data);
  }

  static getShopByRandom(): Promise<Shop[]> {
    return this.request<Shop[]>(
      `/getShopByRandom`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data => data);
  }

  static getShopByRating(): Promise<Shop[]> {
    return this.request<Shop[]>(
      `/getShopByRating`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data => data);
  }

  // 通过用户名获取用户的所有数据
  static async getUserInformation(userName: string): Promise<User> {
    try {
      return this.request<User>(
        `/getUserInformation?userName=${userName}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    } catch (error) {
      console.error('getUserInformation error:', error);
      //throw HttpUtil.
    }
  }

  // 获取搜索结果(Search页面下功能，不是商铺展示处的功能)
  static async getSearchRecommend(searchMessage: string): Promise<Recommendation[]> {
    try {
      // 对中文参数进行URL编码
      const encodedKeyword = encodeURIComponent(searchMessage);
      return this.request<Recommendation[]>(
        `/search/recommendation?keyword=${encodedKeyword}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    } catch (error) {
      console.error('getRecommendInformation error:', error);
      //throw HttpUtil.
    }
  }

  static async getSearchShop(searchMessage: string): Promise<Shop[]> {
    try {
      const encodedKeyword = encodeURIComponent(searchMessage);
      return this.request<Shop[]>(
        `/search/shop?keyword=${encodedKeyword}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    } catch (error) {
      console.error('getShopInformation error:', error);
      //throw HttpUtil.
    }
  }

  static async getSearchUser(searchMessage: string): Promise<User[]> {
    try {
      const encodedKeyword = encodeURIComponent(searchMessage);
      return this.request<User[]>(
        `/search/user?keyword=${encodedKeyword}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    } catch (error) {
      console.error('getUserInformation error:', error);
      //throw HttpUtil.
    }
  }

  static async getShopDetail(shopId: number): Promise<Shop>{
    try{
      return this.request<Shop>(
        `/getShopDetail?shopId=${shopId}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    }catch (error) {
      console.error('getShopDetail error:', error);
    }
  }

  static async getFoodImageDetail(shopId: number): Promise<FoodImage[]>{
    try{
      return this.request<FoodImage[]>(
        `/getFoodImageDetail?shopId=${shopId}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    }catch (error) {
      console.error('getFoodImage error:', error);
    }
  }

  static async getReviewDetail(shopId: number): Promise<Review[]>{
    try{
      return this.request<Review[]>(
        `/getReviewDetail?shopId=${shopId}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    }catch (error) {
      console.error('getReview error:', error);
    }
  }

  static async getMyReview(userId: number): Promise<MyReview[]>{
    try{
      return this.request<MyReview[]>(
        `/getMyReview?userId=${userId}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    }catch (error){
      console.error('getMyReview error:', error);
    }
  }

  static async getMyRecommendation(userId: number): Promise<MyRecommendation[]>{
    try{
      return this.request<MyRecommendation[]>(
        `/getMyRecommendation?userId=${userId}`,
        {
          method: http.RequestMethod.GET,
        }
      ).then(data=>data)
    }catch (error){
      console.error('getMyRecommendation error:', error);
    }
  }

  static async findShopIdByNameAndLocation(shopName: string,location: string): Promise<number>{
    // 对参数进行URL编码，确保中文等特殊字符能正确传输
    const encodedShopName=encodeURIComponent(shopName);
    const encodedLocation=encodeURIComponent(location);

    return this.request<number>(
      `/findShopIdByNameAndLocation?shopName=${encodedShopName}&location=${encodedLocation}`,
      {
        method: http.RequestMethod.GET
      }
    ).then(data=>data);
  } catch (error) {
    console.error('findShopIdByNameAndLocation error:', error);
    throw error;
  }

  public  static BASE_URL = 'http://10.133.68.233:8099';
  public  static httpClient = http.createHttp();
  //通用请求方法
  private static async request<T> (
    url: string,
    options: http.HttpRequestOptions
  ): Promise<T> {
    try {
      const response=await HttpUtil.httpClient.request(
        `${HttpUtil.BASE_URL}${url}`,
        {
          ...options,
          readTimeout: NETWORK_TIMEOUT,
          connectTimeout: NETWORK_TIMEOUT,
          header:{
            'Content-Type': 'application/json',
            ...options.header
          }
        }
      );
      if (response.responseCode===200) {
        return JSON.parse(response.result.toString()) as T;
      }
    }catch (error) {
      //throw HttpUtil.
    }
		return null;
	}
}