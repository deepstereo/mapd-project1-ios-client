//
//  Schema.swift
//  tabTest
//
//  Created by Sergey Kozak on 19/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class Schema: NSObject {
    
    struct Customer: Codable {
        var _id: String = ""
        var businessName: String? = ""
        var address: String? = ""
        var telephone: Int = 0
        var email: String? = ""
        var contactPerson: String? = ""
        var dateCreated: String? = ""
    }
    
    public struct Product: Codable {
        var _id: String = ""
        var productName: String = ""
        var price: Int = 0
        var dateCreated: String = ""
    }
    
    public struct Order: Codable {
        var _id: String = ""
        var customerId: String? = ""
        var productId: String? = ""
        var amount: Int? = 0
        var isPaid: Bool = false
    }
    

}
