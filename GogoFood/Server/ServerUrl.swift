//
//  ServerUrl.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import Foundation

struct ServerUrl {
    
    // static let baseUrl = "http://18.139.48.18:4000/"
    //static let baseUrl = "http://gogofoodapp.com:4000/"
    static let baseUrl = "https://dev.gogofoodapp.com/devapi/"
    static let socketBaseUrl = "https://dev.gogofoodapp.com"
   // static let baseUrl = "https://gogofoodapp.com/api/"
    //static let socketBaseUrl = "https://admin.gogofoodapp.com"

    #if User
    static let appUrl = ServerUrl.baseUrl + "user/"
    #elseif Restaurant
    static let appUrl = ServerUrl.baseUrl + "restaurant/"
    #elseif Driver
    static let appUrl = ServerUrl.baseUrl + "driver/"
    #endif
    
    
    // Authentication
    static let signUpUrl = ServerUrl.appUrl + "signup"
    static let verifyOTPUrl = ServerUrl.appUrl + "verify/otp"
    static let logoutUrl = ServerUrl.appUrl + "logout"
    
    // Home
    
    #if User
    static let userdashboard = ServerUrl.appUrl + "dashboard/"
    static let homeUrl =  ServerUrl.userdashboard + "all/data"

    static let storeInfomationUrl = ServerUrl.userdashboard + "single/restaurant"
    static let topRestaurantUrl = ServerUrl.userdashboard + "top/restaurants"
    static let allRestaurantsUrl = ServerUrl.userdashboard + "all/restaurants"
    static let catgeoryWiseProductUrl = ServerUrl.userdashboard + "category/wise/products"
    static let checkoutUrl = ServerUrl.userdashboard + "checkout"
    static let addToCartUrl = ServerUrl.userdashboard + "add/to/cart"
    static let increaseQuantity = ServerUrl.userdashboard + "increase/quantity"
    static let decreaseQuantity = ServerUrl.userdashboard + "decrease/quantity"
    static let updateTopingUrl = ServerUrl.userdashboard + "update/toppings"
    static let viewCartUrl = ServerUrl.userdashboard + "view/cart"
    static let decreaseDishUrl = ServerUrl.userdashboard + "decrease/dish"
    static let singleDishUrl = ServerUrl.userdashboard + "single/dish"
    static let updateAddressUrl = ServerUrl.userdashboard + "update/address"
    #endif
    
    // order related
    #if Restaurant
    static let liveOrderUrl = ServerUrl.appUrl + "get/new-order"
    static let removeItemUrl = ServerUrl.appUrl + "remove-item"
    static let confirmPayment = ServerUrl.appUrl + "confirm-payment"
    static let notificationUrl  =  ServerUrl.appUrl + "notifications"
    static let getProfile  =  ServerUrl.appUrl + "get/profile"

    #endif
    
    
    //Setting repository
    #if User
    static let updateProfileUrl = ServerUrl.appUrl + "edit/profile"
    #elseif Restaurant
    static let updateProfileUrl = ServerUrl.appUrl + "update/profile"
    #elseif Driver
    static let updateProfileUrl = ServerUrl.appUrl + "edit/profile"
    #endif
    
    #if Restaurant
    static let restaurantTimmingUrl = ServerUrl.appUrl + "add/timing"
    static let getRestaurantTimmingUrl = ServerUrl.appUrl + "get/timing"
    static let updateAddressUrl = ServerUrl.appUrl + "update/address"
    static let addCategoryUrl = ServerUrl.appUrl + "add/category"
    static let updateCategoryUrl = ServerUrl.appUrl + "update/category"
    static let categoryUrl = ServerUrl.appUrl + "category"
    
    static let productUrl = ServerUrl.appUrl + "product"
    static let reportUrl = ServerUrl.appUrl + "report"
    static let reportGraphUrl = ServerUrl.appUrl + "report/graph"
    static let addProductUrl = ServerUrl.appUrl + "add/product"
    static let updateProductUrl = ServerUrl.appUrl + "update/product"
    static let setProductStatus = ServerUrl.appUrl + "product/update/status"
    static let toppingOptionsUrl = ServerUrl.appUrl + "get/options"
    
    static let rejectOrderUrl = ServerUrl.appUrl + "cancel-order"
    static let orderHistoryUrl = ServerUrl.appUrl + "order-history"
    static let todayOrderUrl = ServerUrl.appUrl + "today-order"
    static let acceptOrderUrl = ServerUrl.appUrl + "accept-order"
    static let changeStatusUrl = ServerUrl.appUrl + "chenge/store/status"
    static let commentsFeedUrl = ServerUrl.appUrl + "comments/feed"
    static let getCommentListUrl = ServerUrl.appUrl + "get/comments"
    static let addCommentUrl = ServerUrl.appUrl + "reply/comment"
    static let editCommentUrl = ServerUrl.appUrl + "edit/comment"
    static let removeCommentUrl = ServerUrl.appUrl + "remove/comment"

    
    #endif
    
    
    
    #if Driver
    static let acceptOrderUrl = ServerUrl.appUrl + "accept/order"
    static let onGoingOrderUrl = ServerUrl.appUrl + "home/data"
    static let confirmPickupUrl = ServerUrl.appUrl + "confirm/pickup"
    static let restaurantOrderDetailsUrl = ServerUrl.appUrl + "restaurant/order/details"
    static let updateAddressUrl = ServerUrl.appUrl + "update/current/location"
    #endif
    
    
    
    
}

