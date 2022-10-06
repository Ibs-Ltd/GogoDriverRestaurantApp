//
//  SettingViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 10/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import SBCardPopup
import Localize_Swift

class SettingCellClass: UITableViewCell {
    
    override func awakeFromNib() {
        
    }
}

class SettingViewController: BaseViewController<BaseData>, UITableViewDelegate, UITableViewDataSource {
    
    private let repo = AuthenticationRepository()
    @IBOutlet weak var tableViewOutlet: UITableView!
    let userImageArray = ["address","foodCategory", "foodItem", "ReportPeople", "openingTime", "changeLanguage", "support", "signout", "version"]
    let userTitleArray = ["My Address".localized(), "Food Category".localized(), "Food Items".localized(), "Report".localized(), "Opening Time".localized(), "Change Language".localized(), "Support Center".localized(), "Sign Out".localized(), "Version".localized()]

    let profile = CurrentSession.getI().localData.profile
    let availableLanguages = Localize.availableLanguages()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(title: NavigationTitleString.setting.localized(), image: #imageLiteral(resourceName: "setting_unselected"), selectedImage: nil)
        tableViewOutlet.tableFooterView = UIView()
        setNavigationTitleTextColor(NavigationTitleString.setting.localized())
        print(availableLanguages)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func navigateToBack() {
        print("Back")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell") as! SettingCellClass
        if indexPath.row == 0 {
            cell = SettingCellClass(style: .subtitle, reuseIdentifier: "cell")
            cell.detailTextLabel?.text = profile?.getCompleteAddress(secure: false)
            cell.detailTextLabel?.numberOfLines = 0
        }else {
            cell = SettingCellClass(style: .value1, reuseIdentifier: "cell")
        }
        
        if CurrentSession.getI().getAppType() == .restaurant {
            if indexPath.row == 5 {
                
                if let language  = UserDefaults.standard.object(forKey: "selectedLanguage") as? String{
                    cell.detailTextLabel?.text = language.localized()
                }else{
                    cell.detailTextLabel?.text = "English".localized()
                }
            }
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 7 {
                cell.accessoryType = .none
            }
            if indexPath.row == 8 {
                cell.detailTextLabel?.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                cell.detailTextLabel?.textColor = .blue
                cell.accessoryType = .none
            }
        }
        
        cell.textLabel?.text = userTitleArray[indexPath.row]
        cell.imageView?.image = UIImage(named: userImageArray[indexPath.row])

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectForRestaurantat(indexPath)
    }
    
    func setForCell(_ at: IndexPath) {
        
    }
    
    func didSelectForRestaurantat(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
           let c: CategoryListViewController = self.getViewController(.categoriesList, on: .setting)
           self.navigationController?.pushViewController(c, animated: true)
            break
        case 2:
            let c: ProductListViewController = self.getViewController(.productList, on: .setting)
            self.navigationController?.pushViewController(c, animated: true)
            break
        case 3:
            let vc: ReportViewController = self.getViewController(.report, on: .setting)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
              let vc: ResturantTimeViewController = self.getViewController(.restaurantTime, on: .setting)
              vc.hidesBottomBarWhenPushed = true
              self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            let storyObj = UIStoryboard(name: "Setting", bundle: nil)
            let vcObj = storyObj.instantiateViewController(withIdentifier: "ChangeLanguageViewController") as! ChangeLanguageViewController
            self.navigationController?.pushViewController(vcObj, animated: true)
            break
        case 6:
            let vc: SupportCenterViewController = self.getViewController(.support, on: .setting)
            vc.setViewForRestaurant = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 7:
            createLogout()
            break
            
        default:
            break
        }
    
    }

    func createLogout() {
        let alert = UIAlertController(title: "Logout".localized(), message: "Are you sure you want to sign out?".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (_) in
            self.repo.logoutUser(){ data in
                print(data)
                CurrentSession.getI().onLogout()
                AppDelegate.sharedAppDelegate()?.setFireBaseDelegate()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


