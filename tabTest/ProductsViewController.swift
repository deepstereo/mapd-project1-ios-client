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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductCellTableViewCell
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.productPriceLabel.text = String(products[indexPath.row].price)
        return cell
    }
    

}
