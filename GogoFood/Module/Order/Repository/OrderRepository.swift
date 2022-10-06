//
//  OrderRepository.swift
//  Restaurant
//
//  Created by MAC on 28/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

class OrderRepository: BaseRepository {
    
    #if Restaurant
    func getOrder(onComplition: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.liveOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
        let id = CurrentSession.getI().localData.profile.id
        connectSocket("restaurant_orders", params: ["group":"restaurant_orders-\(id.description)"]){ data in
            if let d: OrdersData = self.getDataFromSocketData(data){
                onComplition(d)
            }
            
        }
    }
    
        func getProfile(onComplition: @escaping responseObject<OTPData>) {
            //showLoader(nil)
            Alamofire.request(ServerUrl.getProfile, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//                let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//                print(dict)
//                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                    let str = String(data: data, encoding: .utf8) {
//                    print(str)
//                }
                if let d: OTPData = self.getDataFrom(item) {
                    onComplition(d)
                }
            }
        }
    
    
    
    
    
    
    
    
    
    
    func notificationListAPI(onComplition: @escaping responseObject<NotificationListRootData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.notificationUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            //print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                //print(str)
//            }

            if let d: NotificationListRootData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
    
    
    func getTodayOrder(onComplition: @escaping responseObject<OrdersData>) {
        //showLoader(nil)
        Alamofire.request(ServerUrl.todayOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        }
        let id = CurrentSession.getI().localData.profile.id
        connectSocket("restaurant_orders", params: ["group":"restaurant_orders-\(id.description)"]){ data in
            if let d: OrdersData = self.getDataFromSocketData(data){
                onComplition(d)
            }
            
        }
    }
    
    func removeItemFromOrder(_ id: [String], becauseOf reason: String, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.removeItemUrl, method: .post, parameters: ["id": id, "reason": reason], encoding: JSONEncoding.default, headers: self.header).responseString { (serverResponse) in
            self.dismiss()
            guard let value = serverResponse.value else{return}
            guard  let responseData = Mapper<BaseObjectResponse<BaseData>>().map(JSONString: value) else {return}
            if responseData.success {
                 response()
            }else{
                self.showError(responseData.message)
            }
           
        }
    }
    
    func rejectOrder(id: Int, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.rejectOrderUrl, method: .post, parameters: ["id":id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
            self.dismiss()
            if let _ : OrderData = self.getDataFrom(item) {
                response()
            }
        }

    }
    
    func orderHistory(onComplition: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.orderHistoryUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }

            
            if let d: OrdersData = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    func orderFinish(_ id: String, response: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.confirmPayment, method: .post, parameters: ["order_id": id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
            self.dismiss()
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            
            let tmpStr = dict["message"] as? String
            if tmpStr == "success"{
                response()
            }
        }
    }
    
//    func orderFinish(_ id: String, response: @escaping emptyResponse) {
//        showLoader(nil)
//        Alamofire.request(ServerUrl.confirmPayment, method: .post, parameters: ["order_id": id], encoding: JSONEncoding.default, headers: self.header).responseString{ (item) in
//
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
//
//            if let _ : BaseData = self.getDataFrom(item) {
//                response()
//            }
//        }
//    }
    
    #elseif Driver
    func getOrderList(onDone: @escaping responseObject<OrdersData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.onGoingOrderUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            if let d: OrdersData = self.getDataFrom(item) {
                onDone(d)
            }
        })
    }
    
    func updateUserLocation(_ location: CLLocationCoordinate2D, onDone: @escaping emptyResponse) {
        showLoader(nil)
        Alamofire.request(ServerUrl.updateAddressUrl,
                          method: .post,
//                          parameters: [ "longitude": location.longitude.description,
//                                        "latitude": location.latitude.description],
                                      parameters: [ "longitude": "76.8463644",
                                                    "latitude": "30.7127433"],
                          encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            if let _ : BaseData = self.getDataFrom(item) {
                onDone()
            }
        })
        
        
    }
    
    
    
    func confirmPickup(order: OrderData, onDone: emptyResponse) {
//        Alamofire.request(ServerUrl.confirmPickupUrl,
//                          method: .post,
//                          parameters: ["restaurant_id": 0,
//                                        "order_id": 1063],
//                          encoding: JSONEncoding.default,
//                          headers: self.header)
//            .responseString(completionHandler: { item in
//                if let _: BaseData = self.getDataFrom(item) {
//
//                }
//
//            })
        onDone()
    }
    
    
    func getOrderDetail(
        _ order: OrderData,
        onDone: @escaping responseObject<OrderDetailData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.restaurantOrderDetailsUrl,
                          method: .post,
                          parameters: ["restaurant_id": order.order_id?.restaurant_wise?.first?.restaurant_id?.id ?? 0,
                                       "order_id": order.order_id?.id ?? 0],
                          encoding: JSONEncoding.default, headers: self.header)
            .responseString(completionHandler: { response in
                if let d: OrderDetailData = self.getDataFrom(response) {
                    onDone(d)
                }
            })
        
    }
    
  
    #endif
    
    func setAvailaiblityStatus(_ status: String, onDone: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.changeStatusUrl,
                          method: .post,
                          parameters: ["status": status],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString { (item) in
                
            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
            print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                print(str)
            }
                
            if let _ : BaseData = self.getDataFrom(item) {
                onDone()
            }
        }
    }
    
    func acceptOrder(_ orderId: Int, done: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.acceptOrderUrl,
                          method: .post,
                          parameters: ["order_id": orderId],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString { (data) in
                
//            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
//            print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
                
            if let _: BaseData = self.getDataFrom(data) {
                 done()
            }
            self.dismiss()
        }
    }
    
//    func setAvailaiblityStatus(_ status: String, onDone: @escaping emptyResponse) {
//        Alamofire.request(ServerUrl.changeStatusUrl,
//                          method: .post,
//                          parameters: ["status": status],
//                          encoding: JSONEncoding.default,
//                          headers: self.header)
//            .responseString { (item) in
//            if let _ : BaseData = self.getDataFrom(item) {
//                onDone()
//            }
//        }
//    }

}
class NotificationListRootData: BaseData {
    
    var notifications : [NotificationList]?
    
    override func mapping(map: Map) {
        
        notifications <- map["notifications"]
    }
}
class NotificationList: BaseData {
    
    var v : Int?
    var nid : Int?
    var createdAt : String?
    var notificationId : NotificationId?
    var read : String?
    var type : String?
    var updatedAt : String?
    var userId : String?
    
    override func mapping(map: Map) {
        
        v <- map["__v"]
        nid <- map["_id"]
        createdAt <- map["created_at"]
        notificationId <- map["notification_id"]
        read <- map["read"]
        type <- map["type"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
    }
}
class NotificationId: BaseData {
    
    var v : Int?
    var nid : Int?
    var createdAt : String?
    var descriptionField : String?
    var image : String?
    var notifyType : String?
    var type : String?
    var scheduleDate : String?
    var scheduleTime : String?
    var status : String?
    var title : String?
    var updatedAt : String?
    var video : String?
    var dish_id:Int?
    override func mapping(map: Map) {
        
        v <- map["__v"]
        nid <- map["_id"]
        dish_id <- map["dish_id"]
        type <- map["type"]
        createdAt <- map["created_at"]
        descriptionField <- map["description"]
        image <- map["image"]
        notifyType <- map["notify_type"]
        scheduleDate <- map["schedule_date"]
        scheduleTime <- map["schedule_time"]
        status <- map["status"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        video <- map["video"]
    }
}
