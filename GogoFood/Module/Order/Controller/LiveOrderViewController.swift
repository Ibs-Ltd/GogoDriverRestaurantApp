//
//  LiveOrderViewController.swift
//  Restaurant
//
//  Created by MAC on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import CoreLocation
import SBCardPopup

class LiveOrderViewController: BaseTableViewController<OrdersData> {
    
    @IBOutlet weak var const_height: NSLayoutConstraint!
    @IBOutlet weak var colVw_Orders: UICollectionView!{
           didSet{
               colVw_Orders.delegate = self
               colVw_Orders.dataSource = self
           }
       }
    @IBOutlet weak var onlineStatus: UISwitch!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var badgeImage: UIImageView!
    private let repo = OrderRepository()
    private var liveOrder: [OrderData] = []
    private var acceptedOrder: [OrderData] = []
    private var acceptedDriverOrder: [OrderInfoData] = []
    let locationManager = CLLocationManager()

    var checkStatus = false
    var transparentBackground : UIView?
    var opaqueView = UIView()
    private var timer: Timer?
    let mainView = StatusView.instantiate(message: "Hello World.")

    override func viewDidLoad() {
        nib.append(TableViewCell.restaurantHistoryTableViewCell.rawValue)
        super.viewDidLoad()
        repo.connectSocket("restaurant_status", params: ["restaurant_id":self.data?.id,"restaurant_status":"offline"]) { (response) in
            print(response)
        }
        
        createNavigationLeftButton(nil)
        self.navigationItem.rightBarButtonItem = createNotificationBarButton()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.const_height.constant = 0
        self.navigationController?.hidesBottomBarWhenPushed = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name.newOrders, object: nil)
        repo.getProfile { (profile) in
            if profile.profile.restaurant_status == "4"{
                self.setOrder()
                self.checkStatus = true
            }else  if profile.profile.restaurant_status == "3" {
                self.setupOpaqueView("Your Account is in pending state.Please wait till it will be approved by Admin.")
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fetchData(_:)), userInfo: nil, repeats: true)
            }else if  profile.profile.restaurant_status == "5"{
                self.setupOpaqueView("Your Account is De-activated by Admin.Please contact to admin for further information.")
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fetchData(_:)), userInfo: nil, repeats: true)
            

//                let sb = UIStoryboard(name: StoryBoard.order.rawValue, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: Controller.chooseOrder.rawValue) as! OrderChoiceViewController
//                vc.hidesBottomBarWhenPushed = true
//                let card = SBCardPopupViewController(contentViewController: vc)
//                card.disableTapToDismiss = false
//                card.disableSwipeToDismiss = false
//                card.show(onViewController: self)
//                self.checkStatus = false
//                self.view.isUserInteractionEnabled = false
//
//                let c = self.storyboard?.instantiateViewController(withIdentifier: "RestuarentStatus_VC") as! RestuarentStatus_VC
//                  let cardPopup = SBCardPopupViewController(contentViewController: c)
//                  cardPopup.show(onViewController: self)
            }
        }
    }
    @objc func notificationReceived(_ notification: Notification) {
        setOrder()
    }

    @objc func appWillEnterForeground() {
        if self.viewIfLoaded?.window != nil {
            // viewController is visible
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }else{
                let alert = UIAlertController(title: "Location Error", message: "Please enable location", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Enable Location", style: .default, handler: { (_) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, completionHandler: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    override func createNavigationLeftButton(_ withTitle: String?) {
        self.profileImage.contentMode = .scaleAspectFill
        ServerImageFetcher.i.loadProfileImageIn(profileImage, url: CurrentSession.getI().localData.profile.profile_picture ?? "")
    }
    
    @IBAction func showProfile(_ sender: UIButton) {
        let c: EditProfileViewController = self.getViewController(.editProfile, on: .setting)
        c.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(c, animated: true)
        
    }
    
    deinit {
        repo.disconnectSocket()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1)
        ? acceptedOrder.isEmpty ? 1 : acceptedOrder.count
        : liveOrder.isEmpty ? 1 : liveOrder.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getCellFor(indexPath: indexPath, tableView: tableView)
    }
    
    func getCellForEmpty(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmptyWaitingTableViewCell
        #if Driver
        cell.imageVie.image = UIImage(named: "waiting")
        #endif
        cell.imageVie.isHidden = (indexPath.section == 1)
        cell.emptyMessage.isHidden = (indexPath.section == 0)
        cell.emptyMessage.text = AppStrings.noLiveOrder.localized()
        cell.label.text = (indexPath.section == 1)
            ? AppStrings.todayOrder.localized()
            : AppStrings.waitingForNewOrder.localized()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0
        ? liveOrder.isEmpty ? tableView.frame.height / 2 : UITableView.automaticDimension
        : acceptedOrder.isEmpty ? tableView.frame.height / 2 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectat(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let yourLabel: UILabel = UILabel()
        yourLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 40)
        yourLabel.textColor = UIColor.black
        yourLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        if self.liveOrder.isEmpty{
            yourLabel.text = section == 0 ? AppStrings.waitingForNewOrder.localized() : "Today's Order".localized()
        }else{
            yourLabel.text = section == 0 ? "New Task".localized() : "Today's Order".localized()
        }
        headerView.addSubview(yourLabel)
        return headerView
    }
    
    @IBAction func setOnline(_ sender: UISwitch) {
        repo.setAvailaiblityStatus(sender.isOn ? "online" : "Offine") {
            print("Done")
        }
    }
}

// Set Live order for the restaurant
#if Restaurant
extension LiveOrderViewController {
    
    func setOrder() {
        if (CurrentSession.getI().localData.profile.userStatus) == .pending || (CurrentSession.getI().localData.profile.userStatus ?? .inital) == .inital {
            self.showAlert(msg: "Your request is pending from admin. Please wait until admin take action")
        }else{
            repo.getOrder() { item in
                self.repo.getTodayOrder() { item in
                    print(item)
                    self.acceptedOrder = item.order
                    self.tableView.reloadData()
                    self.colVw_Orders.reloadData()
                }
                self.data = item
                self.filterOrder()
            }
        }
    }
    
    private func filterOrder() {
        if let d = self.data {
            self.liveOrder = d.order.filter({$0.getOrderStatus() == .pending}).filter({$0.cart_id?.count != 0}).filter({$0.order_id != nil})
            let calendar = Calendar.current
            self.liveOrder = self.liveOrder.filter({calendar.isDateInToday($0.getDate() ?? Date())})
            if self.liveOrder.count > 0 {
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.const_height.constant = 170
                 //   self.colVw_Orders.animShow()
                }
            }else{
               // colVw_Orders.animHide()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.const_height.constant = 0
                }
            }
            self.tableView.reloadData()
        }
    }
    
  
    
    
    
    func getCellFor(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        // section 0 will show the accepted order
        
        if indexPath.section == 0 {
            return self.liveOrder.isEmpty
            ? getCellForEmpty(indexPath, tableView)
            : getOrderCell(indexPath, tableView)
        }
        return self.acceptedOrder.isEmpty
        ? getCellForEmpty(indexPath, tableView)
        : getOrderCell(indexPath, tableView)
    }
    
    private func getOrderCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "restaurantOrder", for: indexPath) as! RestaurantOrderTableViewCell
        c.selectionStyle = .none
      
        c.isFromLiveOrder = indexPath.section == 1 ? false:true
        c.initView(withData:
            (indexPath.section == 1)
            ? self.acceptedOrder[indexPath.row]
                : self.liveOrder[indexPath.row]
        )
        
        c.onOrderTimeOut = {
            self.showRejectAlert(indexPath: indexPath, isfromTimeOut: true)
        }
        
        c.onRejectOrder = {
            self.showRejectAlert(indexPath: indexPath, isfromTimeOut: false)
        }
        return c
    }
    
    func showRejectAlert (indexPath: IndexPath,isfromTimeOut:Bool) {
        
        if isfromTimeOut == false{
            let alert = UIAlertController.init(title: "Reject Order", message: "Really want to reject order", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
            alert.addAction(
                UIAlertAction(title: "Reject", style: .default, handler: { (_) in
                    self.repo.rejectOrder(id: self.liveOrder[indexPath.row].id, response: {
                        self.setOrder()
//                        self.liveOrder.remove(at: indexPath.row)
//                        self.tableView.reloadData()
                    })
                })
            )
            self.present(alert, animated: true, completion: nil)
        }else{
            self.repo.rejectOrder(id: self.liveOrder[indexPath.row].id, response: {
                self.setOrder()
//                self.liveOrder.remove(at: indexPath.row)
//                self.tableView.reloadData()
            })
        }
    }
    
    func didSelectat(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            if liveOrder.count > 0 {
                let c: OrderViewController = self.getViewController(.viewOrder, on: .order)
                c.data = self.liveOrder[indexPath.row]
                c.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(c, animated: true)
            }
        }else{
            if acceptedOrder.count > 0 {
                let c: OrderViewController = self.getViewController(.viewOrder, on: .order)
                c.data = self.acceptedOrder[indexPath.row]
                c.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(c, animated: true)
            }
        }
    }
}

#else
extension LiveOrderViewController {
    
    func setOrder() {
        repo.getOrderList() { item in
            self.liveOrder = item.newOrder
            item.order.forEach({ (item) in
                let order = OrderData()
                order.order_id = item
                self.acceptedOrder.append(order)
                })
            self.tableView.reloadData()
        }
    }
    
    
    func getCellFor(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        // section 1 will show the accepted order
        if indexPath.section == 0 {
            return self.liveOrder.isEmpty
                ? getCellForEmpty(indexPath, tableView)
                : getOrderCell(indexPath, tableView)
        }
        return self.acceptedOrder.isEmpty
            ? getCellForEmpty(indexPath, tableView)
            : getOrderCell(indexPath, tableView)
    }
    
    private func getOrderCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "driverOrder", for: indexPath) as! DriverOrderTableViewCell
        c.isForAceptedOrder = (indexPath.section == 1)
        if indexPath.section == 0 {
            c.initView(withData: self.liveOrder[indexPath.row])
        }else{
            c.initView(withData: self.acceptedOrder[indexPath.row])
        }
       
        c.onReviewOrder = { isAccepted in
            if indexPath.section == 0 {
              self.onAcceptOrder(indexPath)
            }
        }
        return c
    }
    
    
    func onAcceptOrder(_ indexPath: IndexPath) {
        repo.acceptOrder(self.liveOrder[indexPath.row].order_id?.id ?? 0) {
            self.setOrder()
        }
    }
    
    func didSelectat(_ indexPath: IndexPath) {
        if indexPath.section == 1 {
            let c: DriverMapViewController = self.getViewController(.orderOnMap, on: .map)
            c.data = self.acceptedOrder[indexPath.row]
            c.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(c, animated: true)
        }
        
    }
    
}

#endif
extension LiveOrderViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
       
    }
}


class EmptyWaitingTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageVie: UIImageView!
    @IBOutlet weak var emptyMessage: UILabel!
    override func awakeFromNib() {
        label.text = AppStrings.waitingForNewOrder.localized()
    }
}
class Orders_collectionCell: UICollectionViewCell{
    
    @IBOutlet weak var btn_decline: UIButton!
    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var timer_countDown: KCCircularTimer!
    private var timer: Timer?
    var onOrderTimeOut: (()-> Void)!

    override func awakeFromNib() {
        timer?.invalidate()
        timer = nil
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }
   
    func setupCountDownTimer(_ timer: Int) {
        timer_countDown.animate(from: Double(timer), to: 0)
    }
    
    @objc func fetchData(_ sender:Timer){
        guard  let withData = sender.userInfo as? OrderData else{return}
        if withData.getAutoCheckInTime() == 0{
            sender.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.onOrderTimeOut()
            }
        }else{
            if withData.getAutoCheckInTime() < 0{
                sender.invalidate()
            }
            print(withData.getAutoCheckInTime())
        }
    }
  
    func initView(withData: OrderData) {
        
        
        self.timer?.invalidate()
        self.timer =  nil
        
        let total =    String(format: "%.2f", withData.order_id?.total_amount ?? 0.0)
        lbl_total.text = "$\(total)"
        lbl_distance.text = "\(withData.distance ?? 0.0)KM"
        lbl_deliveryPrice.text = "$\(withData.delivery_charges ?? 0)"

            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchData(_:)), userInfo: withData, repeats: true)
                self.setupCountDownTimer(withData.getAutoCheckInTime())
            }
        }
}

extension LiveOrderViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  liveOrder.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Orders_collectionCell", for: indexPath) as? Orders_collectionCell
        
        if self.liveOrder.count > 0{
        DispatchQueue.main.async {
            cell?.initView(withData: self.liveOrder[indexPath.row])
        }
        cell?.btn_decline.tag = indexPath.row
        cell?.btn_accept.tag = indexPath.row
        cell?.btn_decline.addTarget(self, action: #selector(onClickReject(_ :)), for: .touchUpInside)
        cell?.btn_accept.addTarget(self, action: #selector(onClickAccept(_ :)), for: .touchUpInside)
        
        cell?.onOrderTimeOut = {
                if self.liveOrder.count > 0 && indexPath.row < self.liveOrder.count {
                    self.repo.rejectOrder(id: self.liveOrder[indexPath.row].id, response: {
                        self.setOrder()
                    })
                }
            }
        }
        return cell!
    }
    @objc func onClickReject(_ sender:UIButton){
                    let alert = UIAlertController.init(title: "Reject Order", message: "Really want to reject order", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                    alert.addAction(
                        UIAlertAction(title: "Reject", style: .default, handler: { (_) in
                            self.repo.rejectOrder(id: self.liveOrder[sender.tag].id, response: {
                                self.setOrder()
        //                        self.liveOrder.remove(at: indexPath.row)
        //                        self.tableView.reloadData()
                            })
                        })
                    )
                    self.present(alert, animated: true, completion: nil)
    }
    @objc func onClickAccept(_ sender:UIButton){
        self.repo.acceptOrder((self.liveOrder[sender.tag].order_id?.id) as! Int) {
            print("done")
            self.setOrder()
            oneButtonAlertControllerWithBlock(msgStr: "Your order accepted successfully!", naviObj: self) { (true) in
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 150)
    }

}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
extension LiveOrderViewController{
  
    @objc func fetchData(_ sender:Timer){
        repo.getProfile { (profile) in
            if profile.profile.restaurant_status == "4"{
                self.mainView.removeFromSuperview()
                sender.invalidate()
                self.timer?.invalidate()
                self.timer = nil
            }
        }
            
    }
    func setupOpaqueView(_ status:String) {
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainView.lbl_pending.text  = status
        UIApplication.shared.keyWindow?.addSubview(mainView)
        UIApplication.shared.keyWindow!.bringSubviewToFront(mainView)        
        mainView.tapOnButton = {
            self.mainView.removeFromSuperview()
        }
    }
}
