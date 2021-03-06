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
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var rainbowBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedURL: String = ""
    private var orgImage: UIImage?
    private var editedImage: UIImage?
    private var thumbnailArray: [UIImage] = []
    private var newYPos: Int = 40
    private var isRainbow: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollection.delegate = self
        filterCollection.dataSource = self

        createThumbnailsArray()
        updateImageView()
        setupButtons()
        
        orgImage = createUIImageFromURL(selectedURL)
        editedImage = orgImage

        activityIndicator.hidesWhenStopped = true
    }
    
// MARK:- IBActions
    
    @IBAction func barBtnPostTapped(_ sender: Any) {

        PostHandler.shared.makePostRequest(originalURL: selectedURL, editedUIImage: editedImage!)
        
        let alert = UIAlertController(title: "POST", message: "Image Sent", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Close", style: .default)
        
        alert.view.tintColor = .systemRed
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
    
    @IBAction func addTextTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add Text", message: "Enter text to overlay", preferredStyle: .alert)
        alert.view.tintColor = .darkGray
        alert.addTextField()
        
        let add = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
            let textInput = alert.textFields![0]
            let text = textInput.text ?? ""
            
            let topText = createTextOverlay(with: text, at: newYPos)
            newYPos += 40
            imageView.image = editedImage?.mergeWith(topImage: topText)
            editedImage = imageView.image
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @IBAction func rainbowTapped(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in
            self?.imageView.image = self?.editedImage?.addRainbow(to: (self?.editedImage)!)
            self?.editedImage = self?.imageView.image
            self?.activityIndicator.stopAnimating()
            self?.isRainbow = true
        }
        
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        imageView.image = orgImage
        editedImage = orgImage
        isRainbow = false
    }
    
// MARK:- Methods
    
    private func setupButtons() {
        addBtn.layer.cornerRadius = imageView.layer.frame.height / CGFloat(45)
        rainbowBtn.layer.cornerRadius = imageView.layer.frame.height / CGFloat(45)
        resetBtn.layer.cornerRadius = imageView.layer.frame.height / CGFloat(45)
    }
    
    private func updateImageView() {
        guard let url = URL(string: selectedURL) else { return }
        imageView.kf.setImage(with: url)
    }
    
    private func createUIImageFromURL(_ urlString: String) -> UIImage? {
        var image: UIImage?

        let url = NSURL(string: urlString)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
        }
        return image
    }
    
    private func createThumbnailsArray() {
        for i in 0 ... filterNames.count - 1  {
            let filter = filterTypes[i]
            thumbnailArray.append(UIImage(named: "cuteShiba")!.addFilter(filter: filter))
        }
    }
    
    private func createTextOverlay(with stringToMerge: String, at yPos: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs = [NSAttributedString.Key.font: UIFont(name: "Futura", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]

            let string = stringToMerge
            string.draw(with: CGRect(x: 32, y: yPos, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return img
    }
    
}

// MARK:-  CollectionView Methods
// DataSource
extension EditVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.filterName.text = filterNames[indexPath.row]
        cell.filterImageView.image = thumbnailArray[indexPath.row]
        return cell
    }
}

// Delegate
extension EditVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterTypes[indexPath.row]
        
        if isRainbow {
            activityIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in
                self?.imageView.image = self?.editedImage?.addFilter(filter: filter)
                self?.editedImage = self?.imageView.image
                self?.activityIndicator.stopAnimating()
            }
        } else {
            imageView.image = editedImage?.addFilter(filter: filter)
            editedImage = imageView.image
        }
    }
}
