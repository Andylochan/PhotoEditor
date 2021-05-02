//
//  UIImage + Filters.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

import UIKit

let filterNames = ["Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
let filterTypes: [FilterType] = [.Chrome, .Fade, .Instant, .Mono, .Noir, .Process, .Tonal, .Transfer]

enum FilterType : String {
    
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
    
}

extension UIImage {
    
    func addFilter(filter : FilterType) -> UIImage {
        
        let filter = CIFilter(name: filter.rawValue)
        
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
    
    func addRainbow(to img: UIImage) -> UIImage {
        // create a CGRect representing the full size of our input iamge
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)

        // figure out the height of one section (there are six)
        let sectionHeight = img.size.height / 6

        // set up the colors
        let red = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.8)
        let orange = UIColor(red: 1, green: 0.7, blue: 0.35, alpha: 0.8)
        let yellow = UIColor(red: 1, green: 0.85, blue: 0.1, alpha: 0.65)
        let green = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 0.5)
        let blue = UIColor(red: 0, green: 0.35, blue: 0.7, alpha: 0.5)
        let purple = UIColor(red: 0.3, green: 0, blue: 0.5, alpha: 0.6)
        let colors = [red, orange, yellow, green, blue, purple]

        let renderer = UIGraphicsImageRenderer(size: img.size)
        let result = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(rect)

            // loop through all six colors
            for i in 0 ..< 6 {
                let color = colors[i]

                // figure out the rect for this section
                let rect = CGRect(x: 0, y: CGFloat(i) * sectionHeight, width: rect.width, height: sectionHeight)

                // draw it onto the context at the right place
                color.set()
                ctx.fill(rect)
            }

            // draw our input image over using Luminosity mode, with a little bit of alpha to make it fainter
            img.draw(in: rect, blendMode: .luminosity, alpha: 0.6)
        }

        return result
    }
    
}

