//
//  Thumbnail + Filter.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

// NOTE ##############
/*
   Use to apply thumbnail images to the filter collectionView's imageViews.
   Causes minor UI holdup due to heavy load applying the filters.
   Should be run async
*/

//    var thumbnailArray: [UIImage] = []

//    createThumbnails()

//    private func createThumbnails() {
//        var tempArray: [UIImage] = [myImage!]
//
//        for i in 0 ... filterNames.count - 1 {
//            let tempImage = myImage
//            let filter = filterTypes[i]
//            tempArray.append((tempImage?.addFilter(filter: filter))!)
//        }
//
//        thumbnailArray = tempArray
//    }

//    cell.filterImageView.image = thumbnailArray[indexPath.row]
