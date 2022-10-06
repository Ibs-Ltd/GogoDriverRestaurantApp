//
//  RestaurantOrderTableViewCell.swift
//  Restaurant
//
//  Created by MAC on 02/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class RestaurantOrderTableViewCell: BaseTableViewCell<OrderData> {

 
    @IBOutlet weak var  orderItem_lbl: UILabel!
     @IBOutlet weak var totalAmount_lbl: UILabel!
    
    
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var numberOfItem: UILabel!
    @IBOutlet weak var amount: UILabel!
 
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    @IBOutlet weak var pendingChecking: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var timerLbl: UILabel!

    var isFromLiveOrder = false
    
    var onOrderTimeOut: (()-> Void)!

    
    var onRejectOrder: (()-> Void)!
    private var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        orderItem_lbl.text = "Order items".localized()
        totalAmount_lbl.text = "Total Amount".localized()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        timer?.invalidate()
        timer = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRejectOrder(_ sender: UIButton) {
        onRejectOrder()
    }
    
    @objc func fetchData(_ sender:Timer){
        guard  let withData = sender.userInfo as? OrderData else{return}
//        if withData.getAutoCheckInTime() == "0m 1s"{
//            sender.invalidate()
//            self.onOrderTimeOut()
//        }else{
//            print(withData.getAutoCheckInTime())
//            self.timerLbl.text = withData.getAutoCheckInTime()
//        }
    }
    
    override func initView(withData: OrderData) {
        
        DispatchQueue.main.async {
    
            if self.isFromLiveOrder{
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchData(_:)), userInfo: withData, repeats: true)
        }else{
            self.timerLbl.text = " "
                if self.timer != nil{
                self.timer?.invalidate()
            }
        }
            
            self.orderTime.text = TimeDateUtils.getAgoTime(fromDate: withData.getCreatedTime())
            let total =    String(format: "%.2f", withData.order_id?.total_amount ?? 0.0)
            self.orderIdLbl.text =  "#" + (withData.order_id?.id.toString())!
            self.amount.text = "$" + total
            self.orderId.text = withData.user_id?.name ?? ""
            self.userPhoneNumber.text = withData.user_id?.mobile ?? ""
            ServerImageFetcher.i.loadProfileImageIn(self.userImage, url: withData.user_id?.profile_picture ?? "")
            self.userImage.contentMode = .scaleAspectFill
            self.numberOfItem.text = withData.cart_id?.count.description
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                if withData.getOrderStatus() == .accept || withData.getOrderStatus() == .driverAssigned{
                    self.cellButton.setTitle("Accepted".localized(), for: .normal)
                    self.cellButton.backgroundColor = AppConstant.tertiaryColor
                    self.cellButton.isUserInteractionEnabled = false
                }else if withData.getOrderStatus() == .completed || withData.getOrderStatus() == .arrived || withData.getOrderStatus() == .dispatched || withData.getOrderStatus() == .started{
                    self.cellButton.setTitle("Completed".localized(), for: .normal)
                    self.cellButton.backgroundColor = AppConstant.appBlueColor
                    self.cellButton.titleLabel!.adjustsFontSizeToFitWidth = true
                    self.cellButton.isUserInteractionEnabled = false
                }else if withData.getOrderStatus() == .driverArrived{
                    self.cellButton.setTitle("Arrived".localized(), for: .normal)
                    self.cellButton.backgroundColor = AppConstant.appBlueColor
                    self.cellButton.titleLabel!.adjustsFontSizeToFitWidth = true
                    self.cellButton.isUserInteractionEnabled = false
                }else if withData.order_id?.getOrderStatus() == .cancel{
                    self.cellButton.setTitle("Cancelled".localized(), for: .normal)
                    self.cellButton.backgroundColor = AppConstant.primaryColor
                    self.cellButton.titleLabel!.adjustsFontSizeToFitWidth = true
                    self.cellButton.isUserInteractionEnabled = false
                }else{
                    self.cellButton.setTitle("Reject".localized(), for: .normal)
                    self.cellButton.backgroundColor = AppConstant.appYellowColor
                    self.cellButton.isUserInteractionEnabled = true
                }
            })
            
    }

        
//        if isFromLiveOrder{
//            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
//                if withData.getAutoCheckInTime() == "27m 30s"{
//                    if self.timer != nil{
//                        self.timer?.invalidate()
//                        self.timer =  nil
//                    }
//                }else{
//                    self.timerLbl.text = withData.getAutoCheckInTime()
//                }
//            }
//        }else{
//            self.timerLbl.text = " "
//            if timer != nil{
//                self.timer?.invalidate()
//            }
//        }
        

    }
}
