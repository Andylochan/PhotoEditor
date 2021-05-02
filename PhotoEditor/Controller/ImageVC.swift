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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imagesArray = [Image]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activityIndicator.color = .systemRed
        activityIndicator.hidesWhenStopped = true
        
        loadImages()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadImages() {
        activityIndicator.startAnimating()
        
        ImageHandler.shared.fetchImages { [unowned self] (result, images) in
            
            if let res = result {
                self.imagesArray = images ?? self.imagesArray
                collectionView.reloadData()
                
                //End activity indicator
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
                print(res ? "Success" : "Error")
            }
        }
    }
    
    private func updateUI(atIndex: Int, imgView: UIImageView) {
        
        guard let url = URL(string: imagesArray[atIndex].url) else { return }
        imgView.kf.setImage(with: url)
        
    }
    
}

// MARK:-  CollectionView Methods
// Datasource
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

// Delegate
extension ImageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        controller.selectedURL = imagesArray[indexPath.row].url
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
