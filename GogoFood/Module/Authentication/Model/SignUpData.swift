//
//  SignU.swift
//  GogoFood
//
//  Created by MAC on 23/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import ObjectMapper

class SignupData: BaseData {
    
    var status = ""
    var otp: Int = 0
    var mobile  = ""
    var countryCode  = ""
    var screen: UserStatus! = .none
    var restaurant: RestaurantProfileData!
    
    override func mapping(map: Map) {
        
     
        #if User
             status <- map["user_status"]
        #elseif Restaurant
              status <- map["restaurant_success"]
                restaurant <- map["restaurant"]
        #endif
        otp <- map["otp"]
        mobile <- map["mobile"]
        
      
        // For UI prespective
        screen  = UserStatus(rawValue: status)
    }
    
}


enum UserStatus: String {
    case inital = "0" // A fresh login
    case addLocation = "1" // verified phone number but not added address
    case addTiming = "2" //Add location need to add timing
    case pending = "3" //Request is pending from admin side
    case activated = "4" // Approve by admin
    case rejected = "5" //Restaurant is Deactivated
    //------------------//
    case none = ""
}
