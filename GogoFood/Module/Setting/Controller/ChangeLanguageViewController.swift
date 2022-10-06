//
//  ChangeLanguageViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 08/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import Localize_Swift
class ChangeLanguageCellClass: UITableViewCell {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var selectBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        selectBtnOutlet.layer.cornerRadius = selectBtnOutlet.frame.height / 2
        selectBtnOutlet.layer.borderColor = UIColor.red.cgColor
        selectBtnOutlet.layer.borderWidth = 0.8
    }
}

class ChangeLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    var countryArray: [String]!
    var flagCountryArray: [String]!
    var isSelected: Int!

    var selectedLanguage:(name:String,value:String) = ("","")
    override func viewDidLoad() {
        super.viewDidLoad()
        countryArray = ["Khmer".localized(), "English".localized(), "Chinese".localized()]
        flagCountryArray = ["khmer-flag", "english-flag", "chinese-flag"]
        tableViewOutlet.tableFooterView = UIView()
        saveBtnOutlet.layer.cornerRadius = saveBtnOutlet.frame.height / 2
        tableViewOutlet.separatorColor = .black
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(countryArray.count)
        return countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell") as! ChangeLanguageCellClass
        cell.countryNameLabel.text = countryArray[indexPath.row]
        cell.imageViewOutlet.image = UIImage(named: flagCountryArray[indexPath.row])
        if isSelected == indexPath.row {
            cell.selectBtnOutlet.setImage(UIImage(named: "circle"), for: .normal)
        } else {
            cell.selectBtnOutlet.setImage(nil, for: .normal)
        }
        cell.selectBtnOutlet.tag = indexPath.row
        cell.selectBtnOutlet.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func selectImage(sender: UIButton) {
        print(sender.tag)
        switch countryArray[sender.tag] {
        case "Khmer":
            self.selectedLanguage.value = "km"
            self.selectedLanguage.name = "Khmer"
        case "English":
            self.selectedLanguage.value = "en"
            self.selectedLanguage.name = "English"
        case "Chinese":
            self.selectedLanguage.value = "zh"
            self.selectedLanguage.name = "Chinese"
        default:
            break;
        }
        isSelected = sender.tag
        tableViewOutlet.reloadData()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        UserDefaults.standard.set(self.selectedLanguage.name, forKey: "selectedLanguage")
        UserDefaults.standard.set(self.selectedLanguage.value, forKey: "LanguageKey")

        Localize.setCurrentLanguage(self.selectedLanguage.value)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inital")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
