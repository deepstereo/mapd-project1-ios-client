//
//  SecondViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 03/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    var products = [Schema.Product]()
    var orders = [Schema.Order]()
    var customers = [Schema.Customer]()
    var orderToUpdate = Schema.Order()
    
    @IBOutlet weak var tableView: UITableView!
    
    // URL Session to get orders data from API
    
    func getOrders () {
        let ordersUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/orders")
        URLSession.shared.dataTask(with: ordersUrl!) { (data, response, error) in
            do {
                self.orders = try JSONDecoder().decode([Schema.Order].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error getting orders: \(error)")
            }
            }.resume()
    
    }
    
    func getProducts () {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                self.products = try JSONDecoder().decode([Schema.Product].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error getting products: \(error)")
            }
            }.resume()
    }
    
    func getCustomers () {
        let url = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                self.customers = try JSONDecoder().decode([Schema.Customer].self, from: data!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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

    
    // Reload table data before view loads
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrders()
        getProducts()
        getCustomers()
        tableView.reloadData()
    }
    
    // TableView implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productID = orders[indexPath.row].productId
        let customerID = orders[indexPath.row].customerId
        var productName = "Not found"
        var customerName = "Not found"
        var customerAddress = "Not found"
        for entry in products {
            if entry._id == productID {
                productName = entry.productName
            }
        }
        for entry in customers {
            if entry._id == customerID {
                customerName = entry.businessName!
                customerAddress = entry.address!
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderCell
        cell.productNameLabel.text = "\(productName)"
        cell.customerLabel.text = "\(customerName), \(customerAddress)"
        cell.amountLabel.text = "\(String(orders[indexPath.row].amount ?? 0)) kg"
        if orders[indexPath.row].isPaid == true {
            cell.paidSwitch.setOn(true, animated: true)
        } else {
            cell.paidSwitch.setOn(false, animated: true)
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func paidSwitchChange(_ sender: UISwitch) {
        let cell = sender.superview?.superview as! OrderCell
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

