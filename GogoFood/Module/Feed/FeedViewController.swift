//
//  FeedViewController.swift
//  GogoFood
//
//  Created by MAC on 19/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FeedViewController: BaseTableViewController<BaseData> {
    
    @IBOutlet var noRecordView : UIView!
    private let repo = MapRepository()
    
    var feedListArray : [FeedCommentsList]!
    
    override func viewDidLoad() {
        nib = [TableViewCell.foodDetailTableViewCell.rawValue]
        super.viewDidLoad()
        setNavigationTitleTextColor(NavigationTitleString.feed.localized())

        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.repo.getFeedList { (data) in
            self.feedListArray = data.feedCommentsList.unique(map: {$0.productData?._id})
            if self.feedListArray.count == 0{
                self.noRecordView.isHidden = false
            }else{
                self.noRecordView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.feedListArray == nil{
            return 0
        }
        return self.feedListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodDetailTableViewCell") as! FoodDetailTableViewCell
        cell.restaurantID = self.feedListArray[indexPath.row].restaurantId
        cell.initView(withData: self.feedListArray[indexPath.row].productData!)
        cell.soldLabel.isHidden = true
        return cell
    }
    
    override func createNavigationLeftButton(_ withTitle: String?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        imageView.image = UIImage(named: "backBtn")
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToBack))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
        let barBtn = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    @objc func navigateToBack() {
        print("Back")
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        vc.producrtID = self.feedListArray[indexPath.row].productData!
        vc.restaurantID = self.feedListArray[indexPath.row].restaurantId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
