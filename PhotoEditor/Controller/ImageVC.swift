//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

import UIKit
import Kingfisher

class ImageVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imagesArray = [Image]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Tap To Edit"
        
        loadImages()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadImages() {
        
        ImageHandler.shared.fetchImages { [unowned self] (result, images) in
            
            if let res = result {
                self.imagesArray = images ?? self.imagesArray
                collectionView.reloadData()
                
                print(res ? "Success" : "Error")
            }
        }
    }
    
    private func updateUI(atIndex: Int, imgView: UIImageView) {
        
        guard let url = URL(string: imagesArray[atIndex].url) else { return }
        imgView.kf.setImage(with: url)
        
    }
    
}

// MARK:-  Datasource
extension ImageVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        updateUI(atIndex: indexPath.row, imgView: cell.imageView)
        return cell
        
    }
}

// MARK:-  Delegate
extension ImageVC: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
}