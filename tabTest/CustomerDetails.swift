//
//  CustomerDetails.swift
//  tabTest
//
//  Created by Sergey Kozak on 05/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class CustomerDetails: UITableViewController {
    
    var selectedCustomer = Schema.Customer()
    var customers = [Schema.Customer()]
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    
    // URL Session to download json data
    func getCustomerById () {
        let sourceUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers/\(selectedCustomer._id)")
        URLSession.shared.dataTask(with: sourceUrl!) { (data, response, error) in
            do {
                self.selectedCustomer = try JSONDecoder().decode(Schema.Customer.self, from: data!)
                print("get gustomer from API")
                // To avoid warning from XCode tableView will be reloaded in main thread
                DispatchQueue.main.async {
                    self.businessName.text = self.selectedCustomer.businessName
                    self.address.text = self.selectedCustomer.address
                    self.phone.text = String(self.selectedCustomer.telephone)
                    self.email.text = self.selectedCustomer.email
                    self.contact.text = self.selectedCustomer.contactPerson
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCustomerById()
        print("view will appear")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
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
        customerOrdersVC.customerId = selectedCustomer._id
        }
    }
 

}
