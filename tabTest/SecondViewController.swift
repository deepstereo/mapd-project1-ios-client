//
//  SecondViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 03/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
//    // Struct for importing Orders from API json
//
//    struct Order: Codable {
//        var _id: String = ""
//        var productName: String = ""
//        var price: Double = 0
//    }

    // API Url
    
    let ordersUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/orders")
    var orders = [CustomerOrdersViewController.Order]()
    @IBOutlet weak var tableView: UITableView!
    
    // URL Session to get orders data from API
    
    func getOrders () {
        URLSession.shared.dataTask(with: ordersUrl!) { (data, response, error) in
            do {
                self.orders = try JSONDecoder().decode([CustomerOrdersViewController.Order].self, from: data!)
                
                // To avoid warning from XCode tableView will be reloaded in main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    // Reload table data before view loads
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrders()
    }
    
    // TableView implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "orderCell")
        cell.textLabel?.text = orders[indexPath.row].product
        cell.detailTextLabel?.text = "Customer ID: \(orders[indexPath.row].customerID ?? "unknown")"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    


}

