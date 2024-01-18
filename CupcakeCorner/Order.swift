//
//  Order.swift
//  CupcakeCorner
//
//  Created by Kirill Baranov on 18/01/24.
//

import Foundation
import Observation

@Observable
class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _user = "user"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    //extras
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    //address
    var user = User()
    
    //cost
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
}

struct User: Codable {
    
    var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "Name")
        }
    }
    
    var address = Address()
    
    init() {
        if let name = UserDefaults.standard.string(forKey: "Name") {
            self.name = name
            return
        }
        
        self.name = ""
    }
    
}

struct Address: Codable {
    
    var streetAddress: String
    
    var city: String
    
    var zip: String
    
    var hasValidAddress: Bool {
        if
            streetAddress.trimmingCharacters(in: .whitespaces).isEmpty ||
                city.trimmingCharacters(in: .whitespaces).isEmpty ||
                zip.trimmingCharacters(in: .whitespaces).isEmpty
        {
            return false
        }
        
        return true
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Address") {
            if let decoded = try? JSONDecoder().decode(Address.self, from: data) {
                self.streetAddress = decoded.streetAddress
                self.city = decoded.city
                self.zip = decoded.zip
                return
            }
        }
        self.streetAddress = ""
        self.city = ""
        self.zip = ""
    }
    
    func saveAddress() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "Address")
        }
    }
}
