//
//  Basket.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 31/12/2020.
//

import Foundation

class Basket {
    
    var id : String!
    var ownerId : String!
    var itemIds : [String]!
    
    init(){
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[KOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
        
    }
}
//MARK: DOWNLOAD ITEMS

func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping(_ basket: Basket?) -> Void) {
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0{
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else{
            completion(nil)
        }
    }
    
}

//MARK: save to firebase
func saveBasketToFirestore(_  basket: Basket){
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String : Any])
}

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds], forKeys: [KOBJECTID as NSCopying, kITEMIDS as NSCopying,KOBJECTID as NSCopying])
    }
