//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by MAC on 22/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class FeedDetailViewController: BaseTableViewController<BaseData>,UIGestureRecognizerDelegate{

    private let repo = MapRepository()
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentView : UIView!
    
    var commentListArray : [CommentList]!
    var producrtID : ProductData!
    var commentID : String!
    var noti: (dishID:Int,isFromNoti:Bool) = (0,false)
    var isEditComment = false
    var editedCommentStr = ""
    var restaurantID: RestaurantsData!

    override func viewDidLoad() {
        nib = [TableViewCell.foodDetailTableViewCell.rawValue,
               TableViewCell.commentTableViewCell.rawValue,
               TableViewCell.commentTableViewCell1.rawValue,
               TableViewCell.commentTableViewCell2.rawValue]

        super.viewDidLoad()
        setNavigationTitleTextColor(NavigationTitleString.feedDetail.localized())
        createNavigationLeftButton(nil)
        self.tableView.tableFooterView = UIView()
        ServerImageFetcher.i.loadProfileImageIn(userImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
        self.commentView.isHidden = true
        self.callCommentListAPI()
        setupLongPressGesture()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name.dishCommnets, object: nil)
    }
    @objc func notificationReceived(_ notification: Notification) {
        callCommentListAPI()
    }

    //MARK:: Longpress Gesture
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if indexPath.section == 1 {
                    if self.commentListArray[indexPath.row].restaurantComment == nil{
                            print("onLongPressGesture")
                            self.commentView.isHidden = false
                            self.commentTxt.becomeFirstResponder()
                            self.commentID = self.commentListArray[indexPath.row].cid?.toString()
                    }else{
                            let confirmationAlert = UIAlertController(title: "", message: "Choose your option!", preferredStyle: .actionSheet)
                            confirmationAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                                print("Edit")
                                self.commentView.isHidden = false
                                self.commentTxt.becomeFirstResponder()
                                self.commentID = self.commentListArray[indexPath.row].cid?.toString()
                                self.editedCommentStr = (self.commentListArray[indexPath.row].cid?.toString())!
                                self.isEditComment = true
                                self.commentTxt.text = self.commentListArray[indexPath.row].restaurantComment
                                self.commentTxt.becomeFirstResponder()
                            }))
                            confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                                print("Delete")
                                self.commentID = self.commentListArray[indexPath.row].cid?.toString()

                                self.repo.deleteCommentList(self.commentID) { (data) in
                                    self.callCommentListAPI()
                                }
                            }))
                            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(confirmationAlert, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
   func callCommentListAPI() {
    
    let dishID = noti.isFromNoti == true ? noti.dishID.toString() : self.producrtID.id.toString()
       repo.GetItemCommentList(dishID) { (data) in
           self.noti.isFromNoti = false
           self.commentListArray = data.commentList
           self.producrtID = data.productData
           self.tableView.reloadData()
           print(data)
       }
   }

    @IBAction func sendButtonClicked(_ sender: UIButton) {
        if self.commentTxt.text == ""{
            self.showError("Please write your comment!")
        }else{
            if isEditComment{
                repo.editCommentList(self.editedCommentStr, commentStr: self.commentTxt.text!) { (data) in
                    self.commentTxt.text = ""
                    self.isEditComment = false
                    DispatchQueue.main.async {
                        self.callCommentListAPI()
                        self.commentView.isHidden = true
                    }
                }
            }else{
                repo.addCommentList(self.commentID, commentStr: self.commentTxt.text!) { (data) in
                    self.callCommentListAPI()
                    self.commentView.isHidden = true
                }
            }
        }
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
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if noti.isFromNoti{
            return 0
        }else{
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.commentListArray == nil{
                return 0
            }
            return self.commentListArray.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return UITableView.automaticDimension
        }
        return 340
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if self.commentListArray[indexPath.row].restaurantComment == nil{
                let cell = tableView.dequeueReusableCell(withIdentifier: nib[1]) as! CommentTableViewCell
                cell.selectionStyle = .none
                ServerImageFetcher.i.loadProfileImageIn(cell.userImage, url: self.commentListArray[indexPath.row].userId?.profile_picture ?? "")
                cell.usernameLbl.text = self.commentListArray[indexPath.row].userId?.name
                cell.commentLbl.text = self.commentListArray[indexPath.row].userComment
                cell.tapOnReplyButton = {
                    print("tapOnReplyButton")
                    self.commentView.isHidden = false
                    self.commentTxt.text = ""
                    self.commentTxt.becomeFirstResponder()
                    self.commentID = self.commentListArray[indexPath.row].cid?.toString()
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: nib[2]) as! CommentTableViewCell
                cell.selectionStyle = .none
                ServerImageFetcher.i.loadProfileImageIn(cell.userImage, url: self.commentListArray[indexPath.row].userId?.profile_picture ?? "")
                cell.usernameLbl.text = self.commentListArray[indexPath.row].userId?.name
                cell.commentLbl.text = self.commentListArray[indexPath.row].userComment
                //Reply
                ServerImageFetcher.i.loadProfileImageIn(cell.restaurantImg, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
                cell.restaurantReply.text = self.commentListArray[indexPath.row].restaurantComment
                cell.tapOnReplyButton = {
                        let confirmationAlert = UIAlertController(title: "", message: "Choose your option!", preferredStyle: .actionSheet)
                        confirmationAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                            print("Edit")
                            self.commentView.isHidden = false
                            DispatchQueue.main.async {
                                self.commentTxt.becomeFirstResponder()
                            }
                            self.commentID = self.commentListArray[indexPath.row].cid?.toString()
                            self.editedCommentStr = (self.commentListArray[indexPath.row].cid?.toString())!
                            self.isEditComment = true
                            self.commentTxt.text = self.commentListArray[indexPath.row].restaurantComment
                        }))
                        confirmationAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                            print("Delete")
                            self.commentID = self.commentListArray[indexPath.row].cid?.toString()

                            self.repo.deleteCommentList(self.commentID) { (data) in
                                self.callCommentListAPI()
                            }
                        }))
                        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(confirmationAlert, animated: true, completion: nil)
                }
                return cell
            }
        }
        let c =  tableView.dequeueReusableCell(withIdentifier: nib[0], for: indexPath) as! FoodDetailTableViewCell
        if self.commentListArray != nil{
            c.restaurantID = self.commentListArray[indexPath.row].restaurantId
        }
        c.initView(withData: self.producrtID)
        return c
        
    }
    
    
}
