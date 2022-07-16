//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Trung Hieu Luong on 14/07/2022.
//

import Foundation
import UIKit
class MemeDetailViewController: UIViewController{
 
    var meme: Meme!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}
