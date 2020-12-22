//
//  FirebaseCollectionReference.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 21/12/2020.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference( collectionReference: FCollectionReference ) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
