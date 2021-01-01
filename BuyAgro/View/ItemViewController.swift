//
//  ItemViewController.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 30/12/2020.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
    
    // MARK: IBOUTLET
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK VARS
    var item: Item!
    var itemImages : [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 236.0
    private let itemsPerRow: CGFloat = 1
        
    // MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Item name is ", item.name!)
        setupUI()
        downloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
        // Do any additional setup after loading the view.
    }

    // MARK : SETUP UI
    
    private func setupUI(){
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
        
    }
    // MARK: IBACTIONS
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addToBasketButtonPressed(){
        
        // check if user is loged in or show log in view
        
        downloadBasketFromFirestore("1234") { (basket) in
            if basket == nil{
                self.createNewBasket()
            }
            else{
                basket?.itemIds.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [kITEMIDS : basket!.itemIds])
            }
        }
        print("add to basket", item.name!)
    }
    
    //MARK: ADD TO BASKET
    
    private func createNewBasket(){
        let newbasket =  Basket()
        newbasket.id = UUID().uuidString
        newbasket.ownerId = "1234"
        newbasket.itemIds = [self.item.id]
        saveBasketToFirestore(newbasket)
        
        self.hud.textLabel.text = "Added to basket!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateBasket(basket : Basket, withValues : [String : Any]){
        
        updatebasketToFirestore(basket, withValues: withValues) { (error) in
            if error != nil {
                self.hud.textLabel.text = "Error : \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print("error updating basket", error!.localizedDescription)
            }
            else{
                self.hud.textLabel.text = "Added to basket!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
    // MARK: DOWNLOAD PICTURES
    
    private func downloadPictures(){
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0{
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1: itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        if itemImages.count > 0 {
            cell.setUpImageWith(itemImage: itemImages[indexPath.row])
        }
        return cell
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {

    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {

        let availableWidth = collectionView.frame.width - sectionInsets.left

        return CGSize(width: availableWidth, height: cellHeight)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.left

    }
}
