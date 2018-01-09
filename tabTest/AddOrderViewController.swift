//
//  AddOrderViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 07/01/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import UIKit

class AddOrderViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    struct addedOrder: Codable {
        var customerId: String? = ""
        var productId: String? = ""
        var amount: Int? = 0
        var isPaid: Bool = false
    }
    
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    let customerPicker = UIPickerView()
    let productPicker = UIPickerView()
    
    var customers = [Schema.Customer]()
    var products = [Schema.Product]()
    var newOrder = addedOrder()
    var selectedCustomerID = String()
    var selectedProductID = String()
    
    
    // MARK: API actions to get customers and products for pickers
   
    func getCustomers () {
        let sourceUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers")
        URLSession.shared.dataTask(with: sourceUrl!) { (data, response, error) in
            do {
                self.customers = try JSONDecoder().decode([Schema.Customer].self, from: data!)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    
    func getProducts () {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                self.products = try JSONDecoder().decode([Schema.Product].self, from: data!)
            } catch {
                print("Error getting products: \(error)")
            }
            }.resume()
    }
    
    func saveOrderToAPI(_ order: addedOrder) {
        let apiURL = URL(string: "https://serene-eyrie-60807.herokuapp.com/orders")
        var postRequest = URLRequest(url: apiURL!)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(order)
            postRequest.httpBody = payload
            print("New order: \(String(data: payload, encoding: .utf8)!)")
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: postRequest)
        task.resume()
    }
    
    // Clear textfields and send success message
    
    func confirmOrderAdded () {
        let alert = UIAlertController(title: "Thank you!", message: "New order added!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        customerTextField.text = ""
        productTextField.text = ""
        amountTextField.text = ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customerPicker.delegate = self
        productPicker.delegate = self
        
        customerTextField.inputView = customerPicker
        productTextField.inputView = productPicker
        
        getProducts()
        getCustomers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Pickers implementation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == customerPicker {
            return customers.count
        } else {
            return products.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == customerPicker {
            return "\(customers[row].businessName ?? "Not found"), \(customers[row].address ?? "Not found")"
        } else {
            return products[row].productName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == customerPicker {
            customerTextField.text = customers[row].businessName
            selectedCustomerID = customers[row]._id
        } else {
            productTextField.text = products[row].productName
            selectedProductID = products[row]._id
        }
    }
    
    
    @IBAction func cancelAddingOrder(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        newOrder.customerId = selectedCustomerID
        newOrder.productId = selectedProductID
        newOrder.amount = Int(amountTextField.text ?? "0")
        print(newOrder)
        saveOrderToAPI(newOrder)
        confirmOrderAdded()
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
