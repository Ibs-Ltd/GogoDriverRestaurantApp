//
//  MapRepository.swift
//  GogoFood
//
//  Created by MAC on 25/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import ObjectMapper

class MapRepository: BaseRepository {
    
    func getFeedList(onComplition: @escaping responseObject<FeedListRootClass>) {
       showLoader(nil)
       Alamofire.request(ServerUrl.commentsFeedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
        
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            //print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
//
           if let d: FeedListRootClass = self.getDataFrom(item) {
               onComplition(d)
           }
       }
    }
    
    func GetItemCommentList(_ productID : String, onComplition: @escaping responseObject<CommentRootModel>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.getCommentListUrl, method: .post, parameters: ["dish_id":productID], encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
            
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            //print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                print(str)
//            }
            
            if let d: CommentRootModel = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    func addCommentList(_ commentID : String, commentStr : String, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.addCommentUrl, method: .post, parameters: ["comment_id":commentID,"comment":commentStr], encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
            self.dismiss()
//
//            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//            //print(dict)
//            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                let str = String(data: data, encoding: .utf8) {
//                //print(str)
//            }
            
            if let d: SuccessMessageRootModel = self.getDataFrom(item) {
                onComplition(d)
            }
        })
    }
    
    
    func deleteCommentList(_ commentID : String, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
            showLoader(nil)
            Alamofire.request(ServerUrl.removeCommentUrl, method: .post, parameters: ["id":commentID], encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
                self.dismiss()
//                
//                let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
//                //print(dict)
//                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                    let str = String(data: data, encoding: .utf8) {
//                    print(str)
//                }
                
                if let d: SuccessMessageRootModel = self.getDataFrom(item) {
                    onComplition(d)
                }
            })
        }
    
    func editCommentList(_ commentID : String, commentStr : String, onComplition: @escaping responseObject<SuccessMessageRootModel>) {
            showLoader(nil)
            Alamofire.request(ServerUrl.editCommentUrl, method: .post, parameters: ["id":commentID,"comment":commentStr], encoding: JSONEncoding.default, headers: self.header).responseString(completionHandler: { item in
                self.dismiss()
                
    //            let dict = try! JSONSerialization.jsonObject(with: item.data!, options: []) as! NSDictionary
    //            //print(dict)
    //            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
    //                let str = String(data: data, encoding: .utf8) {
    //                //print(str)
    //            }
                
                if let d: SuccessMessageRootModel = self.getDataFrom(item) {
                    onComplition(d)
                }
            })
        }
    
    
    func addUser(_ add: GMSAddress,  onComplition: @escaping responseObject<OTPData>){
        let completeAddress = (add.lines! as [String]).joined(separator: ",")
        #if Restaurant
        let params: Parameters = ["address": completeAddress, "state": add.administrativeArea ?? "", "city": add.locality ?? "", "latitude": add.coordinate.latitude,"longitude": add.coordinate.longitude]
        #else
        let params: Parameters = ["address": completeAddress,
                                  "province":add.subLocality ?? "",
                                  "district": add.locality ?? "",
                                  "commune": add.administrativeArea ?? "",
                                  "village": add.administrativeArea ?? "",
                                  "latitude": add.coordinate.latitude,
                                  "longitude": add.coordinate.longitude]
        #endif
        
        Alamofire.request(ServerUrl.updateAddressUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers: self.header).responseString { (item) in
             #if Restaurant
            if let d: OTPData = self.getDataFrom(item) {
                onComplition(d)
            }
            #else
            CurrentSession.getI().localData.profile.default_address = Mapper<AddressData>().map(JSON: params)
            CurrentSession.getI().saveData()
            onComplition(OTPData())
            #endif
        }
        
        
    }
    
    #if Driver
    func uppdateLocation(
        _ location: CLLocationCoordinate2D,
        onDone: @escaping emptyResponse) {
        Alamofire.request(ServerUrl.updateAddressUrl,
                          method: .post,
                          parameters: ["longitude": location.longitude,
                                       "latitude": location.latitude],
                          encoding: JSONEncoding.default,
                          headers: self.header)
            .responseString(completionHandler: { item in
                if let _: BaseData = self.getDataFrom(item) {
                    onDone()
                }
            })
    }
    
    #endif
   
}
