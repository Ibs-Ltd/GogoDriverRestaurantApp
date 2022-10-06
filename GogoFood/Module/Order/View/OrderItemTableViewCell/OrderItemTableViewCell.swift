//
//  OrderItemTableViewCell.swift
//  Restaurant
//
//  Created by YOGESH BANSAL on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: BaseTableViewCell<CartItemData> {
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: AppStepper!
    @IBOutlet weak var chooseOptionButton: UIButton!
    var onTapToReject: (() -> Void)!
    @IBOutlet weak var itemStatusButtonView: UIView!
    var orderDic : OrderData!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func initViewForDetail() {
        rejectButton.isHidden = false
        chooseOptionButton.isHidden = false
        quantityLabel.isHidden = false
        stepper.isHidden = true
    }
    
    override func initView(withData: CartItemData) {
        super.initView(withData: withData)
        setViewForCart()
    }
    
    private func setViewForCart() {
        if let d = self.data?.first {
            if let product = d.dish_id {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.initViewForDetail()
                    if d.hasRejecetd {
                        self.rejectButton.backgroundColor = AppConstant.primaryColor
                        self.rejectButton.setTitle("Cancelled", for: .normal)
                        self.rejectButton.isUserInteractionEnabled = false
                    }else if d.status == "rejected by restaurant" {
                        self.rejectButton.backgroundColor = AppConstant.primaryColor
                        self.rejectButton.setTitle("Cancelled", for: .normal)
                        self.rejectButton.isUserInteractionEnabled = false
                    }else{
                        if let d = self.orderDic{
                            if d.getOrderStatus() != .pending {
                                self.rejectButton.isHidden = true
                            }
                        }
                        self.rejectButton.backgroundColor = AppConstant.appYellowColor
                        self.rejectButton.setTitle("Reject", for: .normal)
                        self.rejectButton.isUserInteractionEnabled = true
                    }
                })
                
                let image = product.dish_images.count > 0 ?  product.dish_images[0] : ""
                self.foodImage.setImage(image)
                
                
//                if product.image != nil{
//                    ServerImageFetcher.i.loadImageIn(self.foodImage, url: product.image ?? "logo1.png")
//                }else{
//                    self.foodImage.image = UIImage(named: "logo1.png")
//                }
                
                self.foodImage.contentMode = .scaleAspectFill
                self.itemLabel.text = product.name
                
                if product.discount_type == "none"{
                    self.priceLabel.text = d.getTotalPrice()
                    
                }else{
                    let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
                    let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
                    
                    let attributedString1 = NSMutableAttributedString(string:String(format: "$ %.1f", d.item_total!), attributes:attrs1 as [NSAttributedString.Key : Any])
                    attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString1.length))
                    let attributedString2 = NSMutableAttributedString(string:String(format: "\n%@", d.getTotalPrice()), attributes:attrs2 as [NSAttributedString.Key : Any])
                    attributedString1.append(attributedString2)
                    self.priceLabel.attributedText = attributedString2
                }
                self.descriptionLabel.text = d.toppings?.compactMap({$0.addonId!.addonName! + " " + $0.topping_name!}).joined(separator: ",")
                self.chooseOptionButton.isHidden = product.options?.isEmpty ?? true
                self.quantityLabel.text = (d.quantity ?? 0).description
            }
        }
    }
    
    @IBAction func onSelectOption(_ sender: UIButton) {
        
    }
    
    @IBAction func onRejectItem(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.backgroundColor = AppConstant.primaryColor
        }else{
            sender.backgroundColor = AppConstant.appYellowColor
        }
        onTapToReject()
    }
}


