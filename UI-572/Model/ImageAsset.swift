//
//  ImageAsset.swift
//  UI-572
//
//  Created by nyannyan0328 on 2022/05/28.
//

import SwiftUI
import PhotosUI

struct ImageAsset: Identifiable {
    var id = UUID().uuidString
    var thumNail : UIImage?
    var asset : PHAsset
    var index : Int = -1
}


