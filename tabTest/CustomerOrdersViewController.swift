//
//  CustomerOrdersViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 05/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class CustomerOrdersViewController: UITableViewController {
       

    var orderToUpdate = Schema.Order()
    var orderToDelete = Schema.Order()
    var orders = [Schema.Order]()
    var products = [Schema.Product]()
    var customerId = ""
    
    
    // MARK: API Actions
    
    // Get orders for selected customer with ID from previous viewcontroller
    
    func getCustomerOrders() {
        let apiURL = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers/\(customerId)/orders")
        let getTask = URLSession.shared.dataTask(with: apiURL!) { (data, response, error) in
            do {
                self.orders = try JSONDecoder().decode([Schema.Order].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        getTask.resume()
    }
    
    // Get products from API to set product name in a cell
    
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
    
    
    // Update payment status when switch is flipped
    
    func updatePaymentStatus (forOrderId id: String) {
        let apiURL = URL(string: "https://serene-eyrie-60807.herokuapp.com/orders/\(id)")
        var putRequest = URLRequest(url: apiURL!)
        putRequest.httpMethod = "PUT"
        putRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(self.orderToUpdate)
            putRequest.httpBody = payload
            print("status updated to \(orderToUpdate.isPaid)")
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: putRequest)
        task.resume()
    }
    
    // Delete order with id
    
    func deleteOrder(withId id: String) {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/orders/\(id)")
        var delRequest = URLRequest(url: url!)
        delRequest.httpMethod = "DELETE"
        delRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        do {
            let payload = try encoder.encode(self.orderToDelete)
            delRequest.httpBody = payload
            print("Delete order: \(String(data: payload, encoding: .utf8)!)")
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: delRequest)
        task.resume()
    }

    
    // Perform API Actions before view appears
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCustomerOrders()
        getProducts()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getCustomerOrders()
        getProducts()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    
    // Create custom table cell with order details and data from API
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var productName = "Not found"
        var isPaid = Bool()
        
        for product in products {
            if product._id == orders[indexPath.row].productId {
                productName = product.productName
            }
        }
        if orders[indexPath.row].isPaid == true {
            isPaid = true
        } else {
            isPaid = false
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerOrderCell") as! CustomerOrderCell
        cell.productNameLabel.text = productName
        cell.amountLabel.text = "Amount: \(orders[indexPath.row].amount ?? 0) kg"
        
        if isPaid == true {
            cell.paidSwitch.setOn(true, animated: true)
        } else {
            cell.paidSwitch.setOn(false, animated: true)
        }
        
        return cell
    }
    
    // Allow table editing
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Delete row and order from database
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            orderToDelete = orders[indexPath.row]
            deleteOrder(withId: orderToDelete._id)
            getCustomerOrders()
            tableView.reloadData()
        }
    }

    
    // MARK: Switch action to update payment status
    
    @IBAction func paidSwitchChange(_ sender: UISwitch) {
        let cell = sender.superview?.superview as! CustomerOrderCell
        let indexPath = tableView.indexPath(for: cell)
        var order = orders[(indexPath?.row)!]
        if sender.isOn == true {
            sender.setOn(true, animated: true)
            order.isPaid = true
        } else {
            sender.setOn(false, animated: true)
            order.isPaid = false
        }
        orderToUpdate = order
        updatePaymentStatus(forOrderId: order._id)
    }
    


}
