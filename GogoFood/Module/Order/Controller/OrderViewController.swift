//
//  OrderViewController.swift
//  GogoFood
//
//  Created by MAC on 29/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import SBCardPopup

class OrderViewController: BaseTableViewController<OrderData>, BottomPopupDelegate {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    private let repo = OrderRepository()
    @IBOutlet weak var checkInTimeStack: UIStackView!
    
    @IBOutlet weak var buttonView: NSLayoutConstraint!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var previousVC : String!
    var rejectItemStr : [String]!
    
    var total = ""
    
    @IBOutlet weak var lbl_status: UILabel!
    var orderStatus:String?
    override func
        viewDidLoad() {
        nib = [TableViewCell.orderItemTableViewCell.rawValue,
               TableViewCell.orderAmountTableViewCell.rawValue
        ]
        super.viewDidLoad()
        setView()
        self.createNavigationLeftButton(NavigationTitleString.completeOrder)
    }
    
    func setView() {
        if let d = self.data {
            self.name.text = d.user_id?.name ?? ""
            self.phoneNumber.text = d.user_id?.getPhoneNumber(secure: true)
            self.orderDate.text = TimeDateUtils.getDataWithTime(fromDate: d.getCreatedTime())
            self.address.text = d.user_id?.getCompleteAddress(secure: true)
            ServerImageFetcher.i.loadProfileImageIn(userImage, url: d.user_id?.profile_picture ?? "")
            if d.getOrderStatus() != .pending {
                self.checkInTimeStack.isHidden = true
                self.buttonView.constant = 0
            }
            if d.getOrderStatus() == .driverArrived{
                self.finishButton.isHidden = false
            }
        }
        lbl_status.isHidden = self.previousVC == "history" ? false:true
        lbl_status.textColor = orderStatus != "Accepted" ? AppConstant.primaryColor : AppConstant.tertiaryColor
        lbl_status.text = orderStatus ?? ""
     
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.previousVC == "history"{
            return 2
        }
        if let d = self.data {
            if d.getOrderStatus() == .completed {
                return 2
            }else if d.getOrderStatus() == .cancel {
                return 2
            }
        }
        return 2
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? self.data?.cart_id?.count ?? 0
            : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return  indexPath.section == 0
            ? getOrderItemCell(tableView, indexPath: indexPath)
            : getOrderAmount(tableView, indexPath: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    private func getOrderItemCell(_ tableView: UITableView, indexPath: IndexPath) -> OrderItemTableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: nib[indexPath.section], for: indexPath) as! OrderItemTableViewCell
        c.orderDic = self.data
        c.initView(withData: (self.data?.cart_id![indexPath.row])!)
        c.onTapToReject = {
            if self.data?.getOrderStatus() == .pending{
                self.rejectItem(indexPath)
            }
        }
        return c
    }
    
    func rejectItem(_ indexPath: IndexPath) {
        #if Restaurant
        let cell = tableView.cellForRow(at: indexPath) as! OrderItemTableViewCell
        if cell.rejectButton.isSelected{
            print("Is Select")
            if self.rejectItemStr == nil{
                self.rejectItemStr = [((self.data?.cart_id![indexPath.row].id.toString())!)]
            }else{
                self.rejectItemStr.append((self.data?.cart_id![indexPath.row].id.toString())!)
            }
            self.data?.cart_id![indexPath.row].hasRejecetd = true
        }else{
            print("Is Deselect")
            self.rejectItemStr.removeAll {$0 == ((self.data?.cart_id![indexPath.row].id.toString())!)}
            self.data?.cart_id![indexPath.row].hasRejecetd = false
        }
        if self.rejectItemStr.count > 0{
            self.acceptButton.isHidden = true
            self.rejectButton.isHidden = true
            self.doneButton.isHidden = false
        }else{
            self.acceptButton.isHidden = false
            self.rejectButton.isHidden = false
            self.doneButton.isHidden = true
        }
        #endif
    }
    
    private func getOrderAmount(_ tableView: UITableView, indexPath: IndexPath) -> OrderAmountTableViewCell {
        let c  = tableView.dequeueReusableCell(withIdentifier: nib[indexPath.section], for: indexPath) as! OrderAmountTableViewCell
        let cartData = CartData()
        cartData.cartItems = self.data!.cart_id ?? []
        c.order_id = self.data?.order_id
        c.setViewForDetail()
        c.initView(withData: cartData)
        
        self.total = c.totalAmtLabel.text ?? ""
        return c
    }
    
    @IBAction func finishOrderButtonCllicked(_ sender: UIButton) {
        
        repo.orderFinish((self.data!.order_id?.id.toString())!) {
            oneButtonAlertControllerWithBlock(msgStr: "Your order finished successfully!", naviObj: self) { (true) in
                guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptViewController") as? ReceiptViewController else { return }
                popupVC.orderDic = self.data!
                popupVC.total =  self.total
                popupVC.height = 650
                popupVC.topCornerRadius = 20
                popupVC.presentDuration = 0.33
                popupVC.dismissDuration = 0.33
                popupVC.popupDelegate = self
                popupVC.shouldDismissInteractivelty = false
                popupVC.previousObj = self
                self.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func rejectOrder(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Reject Order", message: "Really want to reject order", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(title: "Reject", style: .default, handler: { (_) in
                self.repo.rejectOrder(id: self.data?.id ?? 0) {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneRejectOrder(_ sender: UIButton) {
        let vc: RejectionReasonViewController = self.getViewController(.reject, on: .order)
        vc.onReject = {reason in
            self.repo.removeItemFromOrder(self.rejectItemStr, becauseOf: reason, response: {
//                self.data?.cart_id![indexPath.row].hasRejecetd = true
//                self.data?.cart_id![indexPath.row].status = "rejected by restaurant"
//                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.tableView.reloadData()
                self.acceptButton.isHidden = false
                self.rejectButton.isHidden = false
                self.doneButton.isHidden = true
            })
        }
        let popUp = SBCardPopupViewController(contentViewController: vc)
        popUp.show(onViewController: self)
    }
    
    @IBAction func onAcceptDishes(_ sender: UIButton) {
        self.repo.acceptOrder((self.data?.order_id!.id)!) {
            print("done")
            oneButtonAlertControllerWithBlock(msgStr: "Your order accepted successfully!", naviObj: self) { (true) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupWillDismiss")
        self.navigationController?.popViewController(animated: true)
    }
}

extension Int{
    func toString() -> String{
        let myString = String(self)
        return myString
    }
}
