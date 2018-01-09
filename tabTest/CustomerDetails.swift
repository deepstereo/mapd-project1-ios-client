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
    
    
    // MARK: API Action
    
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
    
    // Delete customer with id
    
    func deleteCustomer(withId id: String) {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers/\(id)")
        var delRequest = URLRequest(url: url!)
        delRequest.httpMethod = "DELETE"
        delRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(self.selectedCustomer)
            delRequest.httpBody = payload
            print("Delete customer: \(String(data: payload, encoding: .utf8)!)")
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: delRequest)
        task.resume()
    }
    
    // Alert to confirm customer delete
    
    func confirmCustomerDelete () {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this customer?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCustomer(withId: self.selectedCustomer._id)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getCustomerById()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Delete customer
    
    @IBAction func deleteCustomer(_ sender: UIButton) {
        confirmCustomerDelete()
    }
    
    
    
    // MARK: Segues
    
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
