//
//  ProductsViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 07/01/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var products = [Schema.Product]()
    var selectedProduct = Schema.Product()

    
    // MARK: API Operations
    
    func getProducts () {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                self.products = try JSONDecoder().decode([Schema.Product].self, from: data!)
                // To avoid warning from XCode tableView will be reloaded in main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error getting products: \(error)")
            }
            }.resume()
    }
    
    
    // Delete product with id
    
    func deleteProduct(withId id: String) {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/products/\(id)")
        var delRequest = URLRequest(url: url!)
        delRequest.httpMethod = "DELETE"
        delRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(self.selectedProduct)
            delRequest.httpBody = payload
            print("Delete product: \(String(data: payload, encoding: .utf8)!)")
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: delRequest)
        task.resume()
    }
    
    
    
    // Load products and populate table before view appears
    
    override func viewWillAppear(_ animated: Bool) {
        getProducts()
        tableView.reloadData()
        print(products.count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView implementation

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductCellTableViewCell
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.productPriceLabel.text = String(products[indexPath.row].price)
        return cell
    }
    
    // Allow table editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete row and task from database
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedProduct = products[indexPath.row]
            deleteProduct(withId: selectedProduct._id)
            getProducts()
            tableView.reloadData()
        }
    }
    

}
