//
//  CartsViewController.swift
//  ShoppingKart
//
//  Created by Sampada on 1/10/18.
//  Copyright © 2018 Sampada. All rights reserved.
//

import UIKit

class CartsCell: UITableViewCell {
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var removeBlock: (()->())?
    
    @IBAction func btnRemoveTapped(_ sender: Any) {
      self.removeBlock?()
    }
}

class CartsViewController: UITableViewController {

    @IBOutlet var footerView: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    var products: [Product]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.products = CoreDataHelper.fetchAllCarts()
        self.title = "Cart"
    }

    @IBAction func btnPlaceOrderTapped(_ sender: Any) {
        if let proudcts = self.products  {
            for p in proudcts {
                CoreDataHelper.deleteCartItem(id:p.idProduct!)
            }
        }
        
        let alert = UIAlertController(title: "Alert", message: "Order Placed Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.products = CoreDataHelper.fetchAllCarts()
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    static func storyboardInstance() -> CartsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartsViewController") as! CartsViewController
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartsCell", for: indexPath) as! CartsCell
        // Configure the cell...
        let p = products![indexPath.row]
        cell.lblProductName.text = p.name
        cell.lblPrice.text = "Price: \(String(describing: p.price!))"
        cell.removeBlock = {
            CoreDataHelper.deleteCartItem(id: p.idProduct!)
            self.products = CoreDataHelper.fetchAllCarts()
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110)
        
        var totalPrice : Int = 0
        if let allProducts = products {
            if allProducts.count == 0 {
                self.lblTotalPrice.text = "Your Cart is Empty"
                self.btnPlaceOrder.isUserInteractionEnabled = false
            } else {
                for p in allProducts  {
                    totalPrice += p.price!
                }
                self.lblTotalPrice.text = "Total Price: " + String(describing: totalPrice)
                self.btnPlaceOrder.isUserInteractionEnabled = true
            }
            
        } else {
            self.lblTotalPrice.text = "Your Cart is Empty"
            self.btnPlaceOrder.isUserInteractionEnabled = false
        }
        
        return self.footerView
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let p = products?[indexPath.row]
        let vc = ProductViewController.storyboardInstance()
        vc.product = p
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
