//
//  FoodDetailTableViewCell.swift
//  User
//
//  Created by YOGESH BANSAL on 13/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import Cosmos

class FoodDetailTableViewCell: BaseTableViewCell<ProductData> {
    
    @IBOutlet weak var soldLabel: UILabel!
    
    @IBOutlet weak private var quantitySetter: AppStepper!
    @IBOutlet weak var stepper: AppStepper!
    
    @IBOutlet weak private var restaurantImage: UIImageView!
   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak private var proctName: UILabel!
    @IBOutlet weak private var cookingTime: UIButton!
    @IBOutlet weak private var deliveryTime: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var orders: UILabel!
    @IBOutlet weak var soldView: UIView!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var shareCount: UILabel!
    @IBOutlet weak var avtRating: CosmosView!
    
    var restaurantProfile: RestaurantProfileData!
    var restaurantID: RestaurantsData!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func initView(withData: ProductData) {
        super.initView(withData: withData)
        if let r = restaurantProfile {
            restaurantImage.setImage(r.profile_picture ?? "")
//          ServerImageFetcher.i.loadProfileImageIn(restaurantImage, url: r.profile_picture ?? "")
            cookingTime.setTitle(r.getCookingTime(), for: .normal)
            deliveryTime.setTitle(r.getDeliveryTime(), for: .normal)
        }else{
            if let r = restaurantID {
                restaurantImage.setImage(r.restImage )
            }
        }
        
        self.proctName.text = withData.name
        self.productImage.setImage(withData.dish_images[0])
        
        //ServerImageFetcher.i.loadImageIn(self.productImage, url: withData.image ?? "")
        self.price.attributedText = withData.getFinalAmount(stikeColor: AppConstant.appBlueColor, normalColor: UIColor.white, fontSize: 13, inSameLine: false)
        self.orders.text = "\(withData.sold_qty ?? 0)"
        self.soldView.isHidden = (withData.sold_qty ?? 0 == 0)
        
        let like =  "Likes".localized()
        let Comments  = "Comments".localized()
        let share  = "Share".localized()
        
        
        self.likeCount.text = String(format: "%i \(like)", withData.totalLikes)
        self.commentCount.text = String(format: "%i \(Comments)", withData.totalComments)
        self.shareCount.text = String(format: "%i \(share)", withData.totalShare)
        self.avtRating.rating = withData.avgRating ?? 0
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
