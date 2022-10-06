//
//  AddAmountViewController.swift
//  User
//
//  Created by Apple on 30/04/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class ReportFilterViewController: BaseViewController<BaseData>, SBCardPopupContent {

    @IBOutlet var amountTxt : UITextField!
    weak var popupViewController: SBCardPopupViewController?
    
    var allowsTapToDismissPopupCard = true
    var allowsSwipeToDismissPopupCard = true
    
    static func create() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ReportFilterViewController") as! ReportFilterViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(sender: UIButton){
        popupViewController?.close()
    }

    @IBAction func sendButtonPressed(sender: UIButton){
        if self.amountTxt.text == ""{
            showAlert(msg: "Please enter amount!")
        }else{
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
