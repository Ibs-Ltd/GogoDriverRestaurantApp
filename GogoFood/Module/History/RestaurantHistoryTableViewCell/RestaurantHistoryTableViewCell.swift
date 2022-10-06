//
//  RestaurantHistoryTableViewCell.swift
//  Restaurant
//
//  Created by YOGESH BANSAL on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RestaurantHistoryTableViewCell: BaseTableViewCell<OrderData> {
    
    //translation
    
    @IBOutlet weak var trnsorderID: UILabel!
    @IBOutlet weak var transorderName: UILabel!
    @IBOutlet weak var trnsstatus: UILabel!
    @IBOutlet weak var trnstotal: UILabel!
    
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    fileprivate func setupTransaltions(){
        trnsorderID.text = "Order ID".localized()
        transorderName.text = "Items Ordered".localized()
        trnsstatus.text = "Status".localized()
        trnstotal.text = "Total Amount".localized()
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func initView(withData: OrderData) {
        super.initView(withData: withData)
        setupTransaltions()
        let order  = "Order ID".localized()
        orderId.text = "\(order): \(withData.order_id?.id.toString() ?? "")"
        numberOfItems.text = (withData.cart_id?.count ?? 0).description
        orderDate.text = TimeDateUtils.getDataWithTime(fromDate: withData.getCreatedTime())
        DispatchQueue.main.async {
            if withData.getOrderStatus() == .accept{
                self.orderStatus.text = "Accepted"
            }else if withData.getOrderStatus() == .completed || withData.getOrderStatus() == .arrived || withData.getOrderStatus() == .dispatched{
                self.orderStatus.text = "Completed"
            }else if withData.getOrderStatus() == .driverArrived{
                self.orderStatus.text = "Arrived"
            }else if withData.order_id?.getOrderStatus() == .cancel{
                self.orderStatus.text = "Cancelled"
            }else{
                self.orderStatus.text = "Reject"
            }
            if withData.getOrderStatus().rawValue == "cancelled"{
                self.orderStatus.textColor = AppConstant.primaryColor
            }else{
                self.orderStatus.textColor = AppConstant.tertiaryColor
            }
        }
        
        ServerImageFetcher.i.loadProfileImageIn(userImage, url: withData.user_id?.profile_picture ?? "")
        self.userImage.contentMode = .scaleAspectFill
        
        guard var dishtotals = withData.cart_id?.compactMap({$0.calculateTotalPrice()}).reduce(0, +) else {return}
        if let check =  withData.tax_applicable as? String, check ==  "yes" , let tax_percent = withData.tax_percent {
                let tax = dishtotals/100 * tax_percent
                dishtotals = dishtotals + tax
        }
        let total =    String(format: "%.2f", withData.order_id?.total_amount ?? 0.0)
        orderAmount.text = "$" +  total
    }

}
