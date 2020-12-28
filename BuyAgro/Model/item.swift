//
//  item.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 25/12/2020.
//

import Foundation
import UIKit


class Item {
    
    var id: String!
    var categoryID: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[KOBJECTID] as? String
        categoryID = _dictionary[kCATEGORYID] as? String
        name = _dictionary[KNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}

//MARK: Save items func

func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Item).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}


//MARK: Helper functions

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks], forKeys: [KOBJECTID as NSCopying, kCATEGORYID as NSCopying, KNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
}

