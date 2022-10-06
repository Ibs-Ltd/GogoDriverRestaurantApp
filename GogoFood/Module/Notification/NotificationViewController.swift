//
//  NotificationViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class NotificationViewController: BaseTableViewController<BaseData> {
    
    
    private let repo = OrderRepository()
    var notificationListArray =  [NotificationList]()
    override func viewDidLoad() {
        nib = [TableViewCell.notificationTableViewCell.rawValue]
        super.viewDidLoad()
        self.setNavigationTitleTextColor(NavigationTitleString.notification)
        refreshdata()
      
    }

    
    func refreshdata()  {
        self.repo.notificationListAPI() { (data) in
            print(data)
            self.notificationListArray = data.notifications ?? []
            if self.notificationListArray.count == 0{
              //  self.noitemImage.isHidden = false
              //  self.emptyLbl.isHidden = false
            }else{
               // self.noitemImage.isHidden = true
               //self.emptyLbl.isHidden = true
                self.tableView.reloadData()
            }
           // self.refreshControl.endRefreshing()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib[0]) as! NotificationTableViewCell
        cell.downArrayBtn.tag = indexPath.row
        cell.downArrayBtn.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        cell.lbl_title.text = self.notificationListArray[indexPath.row].notificationId?.title ?? ""
        cell.lbl_desc.text = self.notificationListArray[indexPath.row].notificationId?.descriptionField ?? ""
        cell.lbl_time.text = TimeDateUtils.getDateOnly(fromDate: self.notificationListArray[indexPath.row].createdAt!)

        return cell
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.notificationListArray[indexPath.row].notificationId?.type == "comment"{
            let storyboard = UIStoryboard(name: "Feed", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as? FeedDetailViewController
            vc?.noti.isFromNoti = true
            vc?.noti.dishID = self.notificationListArray[indexPath.row].notificationId?.dish_id ?? 0
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
