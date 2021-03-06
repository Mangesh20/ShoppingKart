//
//  ProductsViewController.swift
//  ShoppingKart
//
//  Created by Sampada on 10/01/18.
//  Copyright © 2018 Sampada. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    //Custom cell for displaying product details 
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class ProductsViewController: UITableViewController {
    var category: Category?

    
    static func storyboardInstance() -> ProductsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category?.name
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


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as! ProductCell
        // Configure the cell...
        let p = self.category?.items[indexPath.row]
        cell.lblName?.text = p?.name
        cell.lblPrice.text = "Price: \(p!.price!)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let p = self.category?.items[indexPath.row]
        let vc = ProductViewController.storyboardInstance()
        vc.product = p
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
