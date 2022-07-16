//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Trung Hieu Luong on 14/07/2022.
//

import Foundation
import UIKit
class MemeCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = allMemes[(indexPath as NSIndexPath).row]
        cell.imageView.image = meme.memedImage
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setCellDimensions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    func _setCellDimensions() {
        let space: CGFloat = 10.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailViewController
        detailController.meme = allMemes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
