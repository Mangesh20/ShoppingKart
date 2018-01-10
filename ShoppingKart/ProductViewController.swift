//
//  ProductViewController.swift
//  ShoppingKart
//
//  Created by Sampada on 10/01/18.
//  Copyright © 2018 Sampada. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgViewForProduct: UIImageView!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = product?.name
        self.imgViewForProduct.image = UIImage(named: (product?.url)!)
        self.lblPrice.text = String(describing: product!.price!)
        self.addCartButtonOnRightSide()
    }
    
    func addCartButtonOnRightSide()  {
        let btn = UIBarButtonItem(title: "Cart", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.buttonMoveToCartTapped))
        self.navigationItem.rightBarButtonItem = btn
    }

    //creates and returns storyboard instance of ProductViewController
    static func storyboardInstance() -> ProductViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
    }
    
    @IBAction func btnAddToCartTapped(_ sender: Any) {
        
        if let products = CoreDataHelper.fetchAllCarts() {
            var isProductInCart = false
            //Check if product is already present in cart
            for p in products {
                if p.idProduct == product?.idProduct {
                    self.showAlertForProudctAlereadyPresent()
                    isProductInCart = true
                }
            }
            //If product not in cart add the prodcut to Cart
            if !isProductInCart {
                self.addProductToCart()
            }
            
        } else {
            //If product not in cart add the prodcut to Cart
            self.addProductToCart()
        }
    }
    
    func addProductToCart()  {
        CoreDataHelper.addCart(idProduct: product!.idProduct!, price: product!.price!, imgUrl: product!.url!, name: product!.name!)
        self.showAlertForProductAddition()
    }
    
    func showAlertForProudctAlereadyPresent()  {
        let alert = UIAlertController(title: "Alert", message: "Product already in cart.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go To Cart", style: UIAlertActionStyle.default, handler: { (action) in
            self.buttonMoveToCartTapped()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForProductAddition()  {
        let alert = UIAlertController(title: "Alert", message: "Product added in cart.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go To Cart", style: UIAlertActionStyle.default, handler: { (action) in
            self.buttonMoveToCartTapped()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func buttonMoveToCartTapped()  {
        let vc = CartsViewController.storyboardInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
