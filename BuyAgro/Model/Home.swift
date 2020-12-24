//
//  Home.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 22/12/2020.
//

import UIKit
class Category {
    
    var id : String
    var name: String
    var image : UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[KOBJECTID] as! String
        name = _dictionary[KNAME] as! String
        image = UIImage(named: (_dictionary[KIMAGENAME ] as? String ?? ""))
        
    }
    
}
//MARK DOWNLOAD CATEGORY
func downloadCategoriesFromFirebase(completion : @escaping (_ categoryArray : [Category]) -> Void) {

    var categoryArray: [Category] = []

    FirebaseReference(.Category).getDocuments { (snapshot, error) in

    guard let snapshot = snapshot else {
        completion(categoryArray)
        return

    }
        if !snapshot.isEmpty {
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
        }
    }
        completion(categoryArray)
    }
}


//MARK: Save category functions

func saveCategoryToFirebase(_ category: Category){
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String: Any])
    
}

//MARK: Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id,category.name, category.imageName], forKeys: [KOBJECTID as NSCopying, KNAME as NSCopying, KIMAGENAME as NSCopying])
    
}

//MARK: USE ONCE

func createCategorySet() {
    
    let grains = Category(_name: "Grains", _imageName: "Grains")
    let diaryProduct = Category(_name: "DiaryProduct", _imageName: "DiaryProduct")
    let seafood = Category(_name: "Seafood", _imageName: "Seafood")
    let poultry = Category(_name: "Poultry", _imageName: "Poultry")
    let fertilizersandManures = Category(_name: "Fertilizer/Manures", _imageName: "Fertilizer/Manures")
    let farmCrops = Category(_name: "FarmCrops", _imageName: "FarmCrops")
    let machinery = Category(_name: "Machinery", _imageName: "Machinery")
    let fruitsandVegetables = Category(_name: "Fruits/Vegetables", _imageName: "Fruits/Vegetables")
    
    let arrayOfCategories = [grains, diaryProduct, seafood, poultry, fertilizersandManures, farmCrops, machinery, fruitsandVegetables]
    
    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }
    
    
}
