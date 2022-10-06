//
//  HomeRepository.swift
//  GogoFood
//
//  Created by MAC on 01/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import SocketIO


class HomeRepository: BaseRepository {
    
   
    
    func getHomeData(onComplition: @escaping responseObject<HomeData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.homeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
            
            if let data: HomeData = self.getDataFrom(data) {
                onComplition(data)
            }
        }
    }
    
    
    func getStoreInformation(_ id: Int, onComplition: @escaping responseObject<StoreInfomationData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.storeInfomationUrl, method: .post, parameters: ["restaurant_id": id], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: StoreInfomationData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
        connectSocket("user_single_restaurant", params: ["group": "user_single_restaurant-\(id)"]) { (data) in
            if let d: StoreInfomationData = self.getDataFromSocketData(data) {
                onComplition(d)
            }
        }
    
    }
    
    func getallResturants(top: Bool, onComplition: @escaping responseObject<RestaurantsData>) {
        showLoader(nil)
        Alamofire.request(top ? ServerUrl.topRestaurantUrl : ServerUrl.allRestaurantsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: RestaurantsData = self.getDataFrom(data)  {
                onComplition(d)
            }
        }
    }
    
    func getProductOf(categoryId: String, of restaurantId: Int, limit: Int, page: Int, onComplition: @escaping responseObject<MenuData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.catgeoryWiseProductUrl, method: .post, parameters: ["restaurant_id": restaurantId, "category_id": categoryId, "page": 1, "limit": 10], encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            if let d: MenuData = self.getDataFrom(data)  {
                onComplition(d)
            }
        }
    }
    
    func getDetailOf(_ data: ProductData, onComplition: @escaping responseObject<FoodDetailData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.singleDishUrl, method: .post, parameters: ["id": data.id, "restaurant_id": data.restaurant_id?.id], encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
            if let d: FoodDetailData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
        connectSocket("user_single_dish", params: ["group": "user_single_dish-\(data.id)"]) { (data) in
            if let d: FoodDetailData = self.getDataFromSocketData(data) {
                onComplition(d)
            }
        }
    }
    
    
    
    
}
