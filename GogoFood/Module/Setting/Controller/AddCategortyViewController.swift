//
//  AddCategortyViewController.swift
//  Restaurant
//
//  Created by Crinoid Mac Mini on 26/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit
import ImagePicker
import SBCardPopup

class AddCategortyViewController: BaseViewController<BaseData>, UITextFieldDelegate {

    
    @IBOutlet weak var lbl_categoryName: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    
    
    
    
    
    
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categorydescription: AppDescriptionTextView!
    @IBOutlet weak var categoryImage: UIImageView!
    var imageSelected = false
    private let repo = SettingRepository()
    var categoryData: CategoryData!
    var onDismiss: (()->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptranslations()
        categoryName.delegate = self
      
        if let _ = categoryData {
            initView()
        }
       
    }
    
    func initView() {
        categoryName.text = categoryData.cat_name ?? ""
        categorydescription.setText(categoryData.description ?? "")
        ServerImageFetcher.i.loadImageIn(categoryImage, url: categoryData.image ?? "")
        self.imageSelected = true
    }
    
    func setuptranslations()  {
        //List Food Category
        categoryName.placeholder = categoryName.placeholder?.localized()
        lbl_categoryName.text = "Category Name".localized()
        lbl_category.text = "Add Category".localized()
        btn_save.setTitle("Save".localized(), for: .normal)
        btn_cancel.setTitle("Cancel".localized(), for: .normal)
   
    }
    
    func addCategory(){
        
        
    }
    
    func onAdditon(){
        
        
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = ImagePickerController()
         imagePickerController.delegate = self
         imagePickerController.imageLimit = 1
         
         present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if categoryName.text!.isEmpty  || !self.imageSelected || categorydescription.getText() == AppStrings.enterDescription{
            self.showAlert(msg: "All Field are required")
            
            return
        }
    
        
        repo.modifyCategory(withUpdate: !(self.categoryData == nil), name: categoryName.text!, discription: categorydescription.getText(), image: (self.categoryImage.image?.jpegData(compressionQuality: 0.5)!)!, id: !(self.categoryData == nil) ? categoryData!.id.description : nil) { (_) in
            self.onDismiss()
                 self.dismiss(animated: true, completion: nil)
            
           
        }
    
        
    }
    
 
    
}
extension AddCategortyViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            if let image = images.first{
                 self.categoryImage.image = image
                self.imageSelected = true
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
