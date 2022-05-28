//
//  ImagePickerViewModel.swift
//  UI-572
//
//  Created by nyannyan0328 on 2022/05/28.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
   
    @Published var fetchedImages : [ImageAsset] = []
    @Published var selectedImages : [ImageAsset] = []
    
    
    init() {
        
        fetchImage()
    }
    
    func fetchImage(){
        
        
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
            
            
            let imageAsset : ImageAsset = .init(asset:asset)
            
            self.fetchedImages.append(imageAsset)
        }
    }
}


