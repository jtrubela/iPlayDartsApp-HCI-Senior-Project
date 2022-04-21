//
//  Checkout.swift
//  CheckOUTS
//
//  Created by Justin Trubela on 4/16/22.
//

import Foundation

struct Checkout: Codable {
    var checkoutOptions: [[String : Out]]
}

struct Out: Codable {
    var out: String
}
