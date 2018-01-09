//
//  ProductViewController.swift
//  ShoppingKart
//
//  Created by Mangesh Tekale on 10/01/18.
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
    }

    
    static func storyboardInstance() -> ProductViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
    }
    

    @IBAction func btnAddToCartTapped(_ sender: Any) {
        
        
    }

}
