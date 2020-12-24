//
//  CategoryCollectionViewController.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 21/12/2020.
//

import UIKit


class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Vars
    var categoryArray: [Category] = []
    
//    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
//    private let itemsPerRow: CGFloat = 1
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        downloadCategoriesFromFirebase{ (allCategories) in
//            print("callback is completed")}
//        createCategorySet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }
    

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: view.frame.width, height: 220)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.generateCell(categoryArray[indexPath.row])
        return cell
    }
    
    //Mark: UIcollection view delegate
//
    
    //MARK: Download Categories
    
    private func loadCategories () {

        downloadCategoriesFromFirebase { (allCategories) in
            print("we have", allCategories.count)
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    //MARK: NAVIGATION
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "categoryToItemsSegue" {
//          let vc = segue.destination as! itemsTableViewController
//            vc.category = sender as! Category
//        }
//    }

}


//extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView( collectionView: UICollectionView, layout collectionViewLayout:
//        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
//
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: widthPerItem, height: widthPerItem)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return sectionInsets.left
//
//    }
//}
