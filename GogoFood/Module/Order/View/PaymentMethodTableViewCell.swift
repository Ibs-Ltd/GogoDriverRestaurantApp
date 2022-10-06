//
//  PaymentMethodTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 04/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: BaseTableViewCell<CartData> {

    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var checkOutBtn: UIButton!
   
    @IBOutlet private var paymentMethod: [UIButton]!
    private var paymentMethodType: PaymentMethod = .cod
    var placeOrder: ((_ withPaymentMethod: PaymentMethod)-> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func initView(withData: CartData) {
        self.amountLabel.text = withData.getSubtotal()
    }
    
    @IBAction private func selectPaymentMethod(_ sender: UIButton) {
        self.paymentMethod.forEach({$0.isSelected = !$0.isSelected})
        
        
    }
    
    
    
    @IBAction private func palaceOrder(_ sender: UIButton) {
        placeOrder(self.paymentMethodType)
        
    }
    
}
