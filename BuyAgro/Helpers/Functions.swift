//
//  Functions.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 30/12/2020.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
