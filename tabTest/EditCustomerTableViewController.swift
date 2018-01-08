//
//  EditCustomerTableViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 06/01/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import UIKit

class EditCustomerTableViewController: UITableViewController {
    
    var customerToEdit = Schema.Customer()
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contactPerson: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessName.text = customerToEdit.businessName
        address.text = customerToEdit.address
        telephone.text = String(customerToEdit.telephone)
        email.text = customerToEdit.email
        contactPerson.text = customerToEdit.contactPerson

    }
    
    // MARK: API update customer
    
    @objc func updateCustomer() {
        
        // save textfields to customer object
        updateCustomerDetails()
        
        // send PUT request to API
        let customerUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers/\(customerToEdit._id)")
        var putRequest = URLRequest(url: customerUrl!)
        putRequest.httpMethod = "PUT"
        putRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            do {
                let payload = try encoder.encode(self.customerToEdit)
                putRequest.httpBody = payload
                print(String(data: payload, encoding: .utf8)!)
            } catch {
                print(error)
            }
            let task = URLSession.shared.dataTask(with: putRequest)
            task.resume()

    }
    
    
    func updateCustomerDetails () {
        if let enteredName = businessName.text {
            customerToEdit.businessName = enteredName
        } else {
            customerToEdit.businessName = customerToEdit.businessName
        }
        if let enteredAddress = address.text {
            customerToEdit.address = enteredAddress
        } else {
            customerToEdit.address = customerToEdit.address
        }
        if let enteredPhone = telephone.text {
            customerToEdit.telephone = Int(enteredPhone)!
        } else {
            customerToEdit.telephone = customerToEdit.telephone
        }
        if let enteredEmail = email.text {
            customerToEdit.email = enteredEmail
        } else {
            customerToEdit.email = customerToEdit.email
        }
        if let enteredContactPerson = contactPerson.text {
            customerToEdit.contactPerson = enteredContactPerson
        } else {
            customerToEdit.contactPerson = customerToEdit.contactPerson
        }
        
    }
    
    
    func customerUpdateAlert () {
        let alert = UIAlertController(title: "Thank you!", message: "Customer details updated 👍", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            self.performSegue(withIdentifier: "backToCustomerDetails", sender: self);
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    // MARK: IB Actions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func saveCustomer(_ sender: UIBarButtonItem) {
        updateCustomer()
    }
    

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        updateCustomer()
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "backToCustomerDetails" {
//            let customerDetailsVC = segue.destination as! CustomerDetails
//            customerDetailsVC.selectedCustomer = customerToEdit
//        }
    }
    

}
