//
//  CustomerDetails.swift
//  tabTest
//
//  Created by Sergey Kozak on 05/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class CustomerDetails: UITableViewController {
    
    var customerID = ""
    var selectedCustomer = Schema.Customer()
    var customers = [Schema.Customer()]
    
    @IBOutlet weak var businessName: UITableViewCell!
    @IBOutlet weak var address: UITableViewCell!
    @IBOutlet weak var phone: UITableViewCell!
    @IBOutlet weak var email: UITableViewCell!
    @IBOutlet weak var contact: UITableViewCell!
    
    
    // URL Session to download json data
    func getCustomerById () {
        let sourceUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers/\(selectedCustomer._id)")
        URLSession.shared.dataTask(with: sourceUrl!) { (data, response, error) in
            do {
                self.customers = try JSONDecoder().decode([Schema.Customer].self, from: data!)
                print("view will appear with: \(self.selectedCustomer)")
            } catch {
                print(error)
            }
            }.resume()
    }


    @IBAction func unwindToCustomerDetails(_ sender: UIStoryboardSegue) {
        let editCustomer = sender.source as! EditCustomerTableViewController
        let editedCustomer = editCustomer.customerToEdit
        
        businessName.textLabel?.text = editedCustomer.businessName
        address.textLabel?.text = editedCustomer.address
        phone.textLabel?.text = String(editedCustomer.telephone)
        email.textLabel?.text = editedCustomer.email
        contact.textLabel?.text = editedCustomer.contactPerson
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load: \(selectedCustomer)")

        
        businessName.textLabel?.text = selectedCustomer.businessName
        businessName.detailTextLabel?.text = "Business name"
        
        address.textLabel?.text = selectedCustomer.address
        address.detailTextLabel?.text = "Address"
        
        phone.textLabel?.text = String(selectedCustomer.telephone)
        phone.detailTextLabel?.text = "Phone number"
        
        email.textLabel?.text = selectedCustomer.email
        email.detailTextLabel?.text = "Email"
        
        contact.textLabel?.text = selectedCustomer.contactPerson
        contact.detailTextLabel?.text = "Contact person"
    
    }
    
    
    
    @IBAction func showOrders(_ sender: UIButton) {
        performSegue(withIdentifier: "showCustomerOrders", sender: self)
    }
    
    
    @IBAction func editCustomer() {
        performSegue(withIdentifier: "showEditCustomer", sender: self)
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditCustomer" {
            let editCustomerVC = segue.destination as! EditCustomerTableViewController
            editCustomerVC.customerToEdit = selectedCustomer
        }
        if segue.identifier == "showCustomerOrders" {
        let customerOrdersVC = segue.destination as! CustomerOrdersViewController
        customerOrdersVC.customerID = customerID
        }
        if segue.identifier == "backToCustomerDetails" {
            let editCustomerVC = segue.source as! EditCustomerTableViewController
            selectedCustomer = editCustomerVC.customerToEdit
        }
    }
 

}
