//
//  OrderAmountTableViewCell.swift
//  Restaurant
//
//  Created by YOGESH BANSAL on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class OrderAmountTableViewCell: BaseTableViewCell<CartData> {
    @IBOutlet weak var couponAmount: UILabel!

    @IBOutlet weak var couponStockVw: UIStackView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalAmtLabel: UILabel!
    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var totalText: UILabel!
    
    var order_id : OrderInfoData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func initView(withData: CartData) {
        super.initView(withData: withData)
        
        if let d = order_id{
            if let coupon = d.coupon_code,let couponType = d.coupon_type,let coupon_discount = d.coupon_discount{
               self.couponCode.isHidden = false
                self.couponCode.text = "Promo Applied:: \(coupon)"
                if couponType == "percent"{
                    let totalDish = Double(d.dish_price ?? 0)
                    let discount = Double(coupon_discount)
                    let percent = (totalDish * discount) / 100.0
                    let total =    String(format: "%.2f", percent)
                    couponAmount.text = "$" + total
                }else{
                    let totalDish = d.dish_price ?? 0
                    let percent = totalDish - coupon_discount
                    let total =    String(format: "%.2f", percent)
                    couponAmount.text = "$" + total
                }
            }else{
                couponAmount.text = ""
                self.couponCode.isHidden = true

            }
            
            
            let total =    String(format: "%.2f", d.total_amount ?? 0.0)
            totalAmtLabel.text = "$" + total
        }
        subTotalLabel.text = withData.getSubtotal()
        deliveryLabel.text = (withData.delivery_fee ?? 0.0).description
        vatLabel.text = (withData.vat ?? 0.0).description
    }
    
    func setViewForDetail() {
        
        stackView.isHidden = true
        self.stackView.isHidden = true
        totalText.attributedText = NSAttributedString(string: "Total")
    }
    
    
    
}
