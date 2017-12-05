//
//  AddCustomerTable.swift
//  tabTest
//
//  Created by Sergey Kozak on 04/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class AddCustomerTable: UITableViewController {
    
    struct addedCustomer: Codable {
        var businessName: String? = ""
        var address: String? = ""
        var telephone: Int = 0
        var contactPerson: String? = ""
        var email: String? = ""
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var contactPersonField: UITextField!
    
    let apiURL = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers")
    var newCustomer = addedCustomer()
    
    // Function to save customer to API will be called on button tap
    
    func saveCustomerToAPI() {
        
        var postRequest = URLRequest(url: apiURL!)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        // encoder.outputFormatting = .prettyPrinted
        do {
            let payload = try encoder.encode(self.newCustomer)
            postRequest.httpBody = payload
            print(String(data: payload, encoding: .utf8)!)
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: postRequest)
        task.resume()
    }
    
    // Clear textfields and send success message
    
    func customerAddConfirm () {
        let alert = UIAlertController(title: "Thank you!", message: "New customer added!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        nameField.text = ""
        addressField.text = ""
        phoneField.text = ""
        contactPersonField.text = ""
    }
    
    // Action to save customer to API
    
    @IBAction func saveCustomer(_ sender: UIButton) {
        if let enteredName = nameField.text {
            newCustomer.businessName = enteredName
        } else {
            newCustomer.businessName = " "
        }
        if let enteredAddress = addressField.text {
            newCustomer.address = enteredAddress
        } else {
            newCustomer.address = " "
        }
        if let enteredPhone = Int(phoneField.text!) {
            newCustomer.telephone = enteredPhone
        } else {
            newCustomer.telephone = 0
        }
        if let enteredContactPerson = contactPersonField.text {
            newCustomer.contactPerson = enteredContactPerson
        }
        saveCustomerToAPI()
        customerAddConfirm()
    }
    
    
    // ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add customer"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    

}
