//
//  AddProductViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 07/01/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UITextFieldDelegate {
    
    struct addedProduct: Codable {
        var productName: String = ""
        var price: Int = 1
    }
    
    var newProduct = addedProduct()
    

    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var productPriceField: UITextField!
    
    // MARK: API action to save new product
    
    func saveProductToAPI(_ order: addedProduct) {
        let apiURL = URL(string: "https://serene-eyrie-60807.herokuapp.com/products")
        var postRequest = URLRequest(url: apiURL!)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(order)
            postRequest.httpBody = payload
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: postRequest)
        task.resume()
    }
    
    
    // MARK: IB Actions to save product or dismiss
    
    @IBAction func cancelAddingProduct(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProductPressed(_ sender: UIButton) {
        
        if let enteredName = productNameField.text {
            newProduct.productName = enteredName
        } else {
            emptyFieldWarning()
        }
        newProduct.price = Int(productPriceField.text ?? "1")!
        saveProductToAPI(newProduct)
        confirmProductAdded()
    }
    
    // Display alert if product name is empty
    
    func emptyFieldWarning() {
        let alert = UIAlertController(title: "Oups!", message: "Please enter name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Display alert when product is added
    
    func confirmProductAdded() {
        let alert = UIAlertController(title: "Thank you!", message: "New product added", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        productPriceField.text = ""
        productNameField.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
