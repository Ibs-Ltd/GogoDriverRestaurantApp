/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
import ObjectMapper

class MenuData: BaseData{
    var products: [ProductData] = []
    
    override func mapping(map: Map) {
        #if User
        products <- map["products"]
        #elseif Restaurant
        products <- map["product"]
        #endif
    }
    
}

class ProductData : BaseData {
    var name : String?
    var _id : Int?
    #if Restaurant
    var category_id : CategoryData!
    var options : [Int]?
    var productOption: [OptionData]?
    #else
    var category_id : Int?
    var options : [OptionData]?
    #endif
    var price : Double?
    var is_recomend : String?
    var restaurant_id : RestaurantProfileData?
    
    var avgRating : Double!
    var totalLikes : Int!
    var totalComments : Int!
    var totalShare : Int!
    var description : String?
    var discount_type : String?
    var discount_percentage : Int?
    var coupon_code : String?
    var image : String?
    var dish_images : [String]!
    var sold_qty : Int?
    var created_by : String?
    var status : String?
    private var toppings : String?
    // for ui prespective
    var isActive = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        _id <- map["_id"]
        category_id <- map["category_id"]
        price <- map["price"]
        is_recomend <- map["is_recomend"]
        restaurant_id <- map["restaurant_id"]
        
        avgRating <- map["total_rating"]
        totalLikes <- map["total_likes"]
        totalComments <- map["total_comments"]
        totalShare <- map["total_shares"]
        options <- map["options"]
        #if Restaurant // because some api developer are really ill
        productOption <- map["options"]
        #endif
        description <- map["description"]
        discount_type <- map["discount_type"]
        discount_percentage <- map["discount_percentage"]
        coupon_code <- map["coupon_code"]
        image <- map["image"]
        dish_images <- map["dish_images"]
        sold_qty <- map["sold_qty"]
        created_by <- map["created_by"]
        status <- map["status"]
        toppings <- map["toppings"]
        isActive = (status ?? "" == "Active")
    }
    
    func getCookingTime() -> String {
        if let r = restaurant_id {
            return r.getCookingTime()
        }
        return ""
    }
    
    func getDeliveryTime() -> String {
        if let r = restaurant_id {
            return r.getDeliveryTime()
        }
        return ""
        
    }
    
    
    func getFinalAmount(stikeColor: UIColor, normalColor: UIColor, fontSize: CGFloat, inSameLine: Bool) -> NSAttributedString {
        let attributeString = NSMutableAttributedString()
        let normalAttributes:  [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: normalColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
        if self.discount_type == "Percent" {
            attributeString.append(NSAttributedString(string: "$" + (self.price ?? 0.0).description))
            let strikethroughAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.strikethroughStyle: 1,
                NSAttributedString.Key.strikethroughColor: stikeColor,
                NSAttributedString.Key.foregroundColor: stikeColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            attributeString.addAttributes(strikethroughAttributes, range: NSMakeRange(0, attributeString.length))
            attributeString.append(NSAttributedString(string: inSameLine ? " " : "\n"))
            attributeString.append(NSAttributedString(string:  "$" + getFinalPriceAfterDiscount().description, attributes: normalAttributes))
        }else{
            attributeString.append(NSAttributedString(string: "$" + (self.price ?? 0.0).description, attributes: normalAttributes))
        }
        return attributeString
    }
 
    func getFinalPriceAfterDiscount() -> Double {
        
        if self.discount_type == "percentage"{
            return (self.price ?? 0.0) - ((self.price ?? 0.0) * Double(self.discount_percentage ?? 0)) / 100.0
        }else if self.discount_type == "amount"{
            return (self.price ?? 0.0) - Double(self.discount_percentage ?? 0)
        }
        return self.price ?? 0.0
        
    }
    
}


class ProductPostData: ProductData {
    
    var productImage: UIImage!
    var catedoryId = ""
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        catedoryId <- map["category"]
        price <- map["price"]
        is_recomend <- map["is_recomend"]
        description <- map["description"]
        discount_type <- map["discount_type"]
        discount_percentage <- map["discount_percentage"]
        coupon_code <- map["coupon_code"]
    }
    
}

class ReportsRootModel: BaseData {
    
    var reportsData : [ReportsData] = []
    
    override func mapping(map: Map) {
        reportsData <- map["product"]
    }
}

class ReportsData: BaseData {
    
    var rid : Int?
    var count : Int?
    var name : String?
    var total : Double?
    
    override func mapping(map: Map) {
        rid <- map["_id"]
        count <- map["count"]
        name <- map["name"]
        total <- map["total"]
    }
}

class LineGraphRootModel: BaseData {
    
    var monthWise : [MonthWise] = []
    
    override func mapping(map: Map) {
        monthWise <- map["Month_wise"]
    }
}

class MonthWise: BaseData {
    
    var _id : Int?
    var count : Int?
    var name : String?
    var total : Int?
    
    override func mapping(map: Map) {
        _id <- map["_id"]
        count <- map["count"]
        name <- map["name"]
        total <- map["total"]
    }
}
