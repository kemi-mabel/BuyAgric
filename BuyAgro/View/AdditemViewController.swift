//
//  AdditemViewController.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 26/12/2020.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AdditemViewController: UIViewController {
    
//MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    //MARK: Vars
        var category: Category!
        var gallery: GalleryController!
        let hud = JGProgressHUD(style: .dark)
    
        var activityIndicator: NVActivityIndicatorView?
        
    var itemImages: [UIImage?] = []
    
    //MARK: View Lifecycle
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            print(category.id)

        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1), padding: nil)
            
    }
     //MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        dismissKeayboard()
                
                if fieldsAreCompleted() {
                    saveToFirebase()
                    print("we have values")
                } else {
                    print("Error all fields are required")
                    
                    self.hud.textLabel.text = "All fields are required!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }

    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeayboard()
    }
    
    
    //MARK: Helper functions
        
        private func fieldsAreCompleted() -> Bool {
            
            return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextField.text != "")
        }
        
        private func dismissKeayboard() {
            self.view.endEditing(false)
        }
    
        private func popTheView() {
            self.navigationController?.popViewController(animated: true)
        }
    
    //MARK: Save Item
        private func saveToFirebase() {
            
            showLoadingIndicator()
            
            let item = Item()
            item.id = UUID().uuidString
            item.name = titleTextField.text!
            item.categoryID = category.id
            item.description = descriptionTextField.text
            item.price = Double(priceTextField.text!)
            
            if itemImages.count > 0 {
                
                uploadImages(images: itemImages, itemId: item.id) { (imageLikArray) in
                    
                    item.imageLinks = imageLikArray
                    
                    saveItemToFirestore(item)
                    
                    self.hideLoadingIndicator()
                    self.popTheView()
                }
                
            } else {
                saveItemToFirestore(item)
                popTheView()
            }
            
        }

    
    //MARK: Activity Indicator
        
        private func showLoadingIndicator() {
            
            if activityIndicator != nil {
                self.view.addSubview(activityIndicator!)
                activityIndicator!.startAnimating()
            }
        }

        private func hideLoadingIndicator() {
            
            if activityIndicator != nil {
                activityIndicator!.removeFromSuperview()
                activityIndicator!.stopAnimating()
            }
        }


    //MARK: Show Gallery
        private func showImageGallery() {
            
            self.gallery = GalleryController()
            self.gallery.delegate = self
            
            Config.tabsToShow = [.imageTab, .cameraTab]
            Config.Camera.imageLimit = 6
            
            self.present(self.gallery, animated: true, completion: nil)
        }
    
}


extension AdditemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}


