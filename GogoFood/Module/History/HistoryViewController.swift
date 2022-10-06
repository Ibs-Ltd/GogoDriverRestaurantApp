
//
//  HistoryViewController.swift
//  User
//
//  Created by YOGESH BANSAL on 14/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit

class HistoryViewController: BaseTableViewController<OrderData> {
    
    @IBOutlet var noRecordView : UIView!
    
    private let repo = OrderRepository()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        nib = [TableViewCell.restaurantHistoryTableViewCell.rawValue]
        super.viewDidLoad()
        self.navigationController?.title = "History".localized()
        self.setNavigationTitleTextColor(NavigationTitleString.history)
        repo.orderHistory { (data) in
            self.allItems = data.order
            if self.allItems.count == 0{
                self.noRecordView.isHidden = false
            }else{
                self.noRecordView.isHidden = true
            }
            self.tableView.reloadData()
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        repo.orderHistory { (data) in
            self.allItems = data.order
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: self.nib[0], for: indexPath) as! RestaurantHistoryTableViewCell
        
            c.initView(withData: self.allItems[indexPath.row])
        return c
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? RestaurantHistoryTableViewCell {
            let vc: OrderViewController = self.getViewController(.viewOrder, on: .order)
            vc.data = self.allItems[indexPath.row]
            vc.orderStatus = cell.orderStatus.text ?? ""
            vc.previousVC = "history"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
