//
//  FirstViewController.swift
//  tabTest
//
//  Created by Sergey Kozak on 03/12/2017.
//  Copyright © 2017 Centennial. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // Main API URL
    
    let sourceUrl = URL(string: "https://serene-eyrie-60807.herokuapp.com/customers")
    var customers = [Schema.Customer]()
    @IBOutlet weak var tableView: UITableView!
    
    
    // URL Session to download json data
    func getCustomers () {
        URLSession.shared.dataTask(with: sourceUrl!) { (data, response, error) in
            do {
                self.customers = try JSONDecoder().decode([Schema.Customer].self, from: data!)
                
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
        getCustomers()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    
    // Tableview implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = customers[indexPath.row].businessName
        cell?.detailTextLabel?.text = customers[indexPath.row].address
        return cell!
    }
    
    // Segue to detail view
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customerDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let customerDetailsVC = segue.destination as! CustomerDetails
                customerDetailsVC.selectedCustomer = customers[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "customerDetails", sender: Any?.self)
    }
    
    // Segue to Add customer
    
    @IBAction func showAddCustomer(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewCustomer", sender: self)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

