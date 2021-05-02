//
//  EditVC.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

import UIKit
import Kingfisher

class EditVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterCollection: UICollectionView!
    
    let filterNames = ["Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
    let filterTypes: [FilterType] = [.Chrome, .Fade, .Instant, .Mono, .Noir, .Process, .Tonal, .Transfer]
    
    var selectedURL: String = ""
    var myImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollection.delegate = self
        filterCollection.dataSource = self

        updateImageView()
        
        myImage = createUIImageFromURL()
    }
    
    private func updateImageView() {
        guard let url = URL(string: selectedURL) else { return }
        imageView.kf.setImage(with: url)
    }
    
    private func createUIImageFromURL() -> UIImage? {
        var image: UIImage?
        let urlString = selectedURL

        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
        }
        return image
    }
    
}

// MARK:-  CollectionView Methods
// DataSource
extension EditVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.filterName.text = filterNames[indexPath.row]
        return cell
    }

}

// Delegate
extension EditVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let filter = filterTypes[indexPath.row]
        imageView.image = myImage?.addFilter(filter: filter)
        
    }
}
