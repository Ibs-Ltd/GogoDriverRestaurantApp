/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

enum OrderStatus: String {
    case pending = "pending"
    case cancel = "cancelled"
    case accept = "accepted"
    case dispatched = "dispatched"
    case none
    
    // New status
    case driverAssigned = "driver_assigned"
    case driverArrived = "arrived_to_restaurant"
    case completed = "completed"
    case arrived = "arrived"
    case started = "started"
}


class OrdersData: BaseData {
    #if Driver
    var newOrder: [OrderData] = []
    var order: [OrderInfoData] = []
    #else
    var order: [OrderData] = []
    #endif
    
    
    override func mapping(map: Map) {
        #if Driver
        newOrder <- map["new_orders"]
        order <- map["orders"]
        #else
        order <- map["order"]
        #endif
        
    }
    
}

class SuccessMessageRootModel: BaseData {
    
    var message : String?
    var success : Bool?
    
    override func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
    }
}

class  OrderDetailData: BaseData {
    var order: OrderData!
    override func mapping(map: Map) {
        order <- map["details"]
    }
    
    
}

class OrderData : BaseData {
    var user_id : ProfileData?
    var driver_id : DriverProfileData?
    #if Driver
    var restaurant_id: RestaurantProfileData?
    #else
    var restaurant_id : Int?
    #endif
    var order_id : OrderInfoData?
    var cart_id : [CartItemData]?
    var distance : Double?
    var delivery_charges : Int?
    var delivery_charges_tax : Int?
    
    var tax_applicable:String?
    var tax_percent:Double?
    private var status : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        tax_applicable <- map["tax_applicable"]
        tax_percent <- map["tax_percent"]

        
        user_id <- map["user_id"]
        driver_id <- map["driver_id"]
        restaurant_id <- map["restaurant_id"]
        order_id <- map["order_id"]
        cart_id <- map["cart_id"]
        distance <- map["distance"]
        delivery_charges <- map["delivery_charges"]
        delivery_charges_tax <- map["delivery_charges_tax"]
        status <- map["status"]
    }
    
    func getOrderStatus() -> OrderStatus {
        return OrderStatus.init(rawValue: self.status ?? "") ?? .none
    }
    
    func getOrderStatusAsString() -> String {
        return " \(self.status ?? "") ".capitalized
    }
    
    
    
    
    
    func getColorForStatus() -> UIColor {
        switch OrderStatus.init(rawValue: self.status ?? "") ?? .none {
        case .cancel:
            return AppConstant.primaryColor
        case .pending:
            return AppConstant.appYellowColor
        case .accept:
            return AppConstant.appBlueColor
        default:
            break
        }
        return UIColor.clear
    }
    

    func getAutoCheckInTime()  -> Int {
        let currentDate = Date()
        let now = TimeDateUtils.getDateinDateFormat(fromDate: self.getCreatedTime()).addingTimeInterval(15 * 60)
        let diffDateComponents = Calendar.current.dateComponents([.second], from: currentDate, to: now)
        if  let second = diffDateComponents.second{
            return second
        }
        return 0
    }
    
    
//    func getAutoCheckInTime() -> String {
//        let now = TimeDateUtils.getDateinDateFormat(fromDate: self.getCreatedTime())
//        let endDate = Date().addingTimeInterval(15)
//        let formatter = DateComponentsFormatter()
//        let interval = Calendar.current.dateComponents([.minute], from: now, to: Date())
//
////        if (interval.minute ?? 0){
//            formatter.allowedUnits = [.minute, .second]
//            formatter.unitsStyle = .abbreviated
//            return formatter.string(from: now, to: endDate)!
//       // }
//       // return "0m 0s"
//    }
    
    
    
    
}
