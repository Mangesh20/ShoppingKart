//
//  CategoriesViewController.swift
//  ShoppingKart
//
//  Created by Sampada on 09/01/18.
//  Copyright © 2018 Sampada. All rights reserved.
//

import UIKit


struct Product {
    
    var idProduct : String?
    var name: String?
    var description: String?
    var url: String?
    var code: String?
    var price: Int?
    init() {
        
    }
    
    init(dict: [String: Any]) {
        self.init()
        self.name = dict["name"] as? String
        self.idProduct = dict["id"] as? String
        self.url = dict["url"] as? String
        self.description = dict["description"] as? String
        self.price = dict["price"] as? Int
    }
}

struct Category {
    var items : [Product] = []
    var name: String?
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String
        if let items = dict["items"] as? [[String: Any]] {
            for p in items {
                self.items.append(Product(dict: p))
            }
        }
    
    }
}

class CategoriesViewController: UITableViewController {
    
    var categoriesArray : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parseData()
        self.title = "Categories"
        self.addCartButtonOnRightSide()
    }

    func addCartButtonOnRightSide()  {
        let btn = UIBarButtonItem(title: "Cart", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.buttonMoveToCartTapped))
        self.navigationItem.rightBarButtonItem = btn
    }

    func buttonMoveToCartTapped()  {
        let vc = CartsViewController.storyboardInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func parseData() {
        if let path = Bundle.main.path(forResource: "Catalog", ofType: "json")
        {
            if let jsonData = try?  Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            {
                if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                    if let categories = jsonResult?["categories"] as? [[String: Any]] {
                        for cat in categories {
                            self.categoriesArray.append(Category(dict: cat))
                        }
                    }
                }
                
            }
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriesArray.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        let cat = self.categoriesArray[indexPath.row]
        cell.textLabel?.text = cat.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = self.categoriesArray[indexPath.row]
        let vc = ProductsViewController.storyboardInstance()
        vc.category = cat
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
