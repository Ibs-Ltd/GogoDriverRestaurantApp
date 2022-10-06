//
//  StatusView.swift
//  User
//
//  Created by ItsDp on 04/10/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
class StatusView: UIView {
    var tapOnButton: (() -> ())!
    @IBOutlet weak var lbl_pending: UILabel!

    static func instantiate(message: String) -> StatusView {
        let view: StatusView = initFromNib()
        return view
    }

    
    
    @IBAction func onTap(_ sender: UIButton) {
       // callNumber(phoneNumber: sender.titleLabel?.text ?? "")
      }
    private func callNumber(phoneNumber:String) {

        let number = phoneNumber.replacingOccurrences(of: " " , with: "")
        if let phoneCallURL = URL(string: "telprompt://\(number)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
}

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
