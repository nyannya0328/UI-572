//
//  PopupImagePickerView.swift
//  UI-572
//
//  Created by nyannyan0328 on 2022/05/28.
//

import SwiftUI
import PhotosUI

struct PopupImagePickerView: View {
    
    @Environment(\.self) var env
    
    @StateObject var model : ImagePickerViewModel = .init()
    var onEnd : ()->()
    var onselect : ([PHAsset]) ->()
    var body: some View {
        let deviceSize = UIScreen.main.bounds.size
        
        VStack(spacing:15){
            
            HStack{
                
                Text("Fetched Images")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "xmark.diamond.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }

                
                
                
            }
            .padding([.horizontal,.bottom])
            .padding(.vertical)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                let columns = Array(repeating: GridItem(.flexible(),spacing: 10), count: 4)
                
                LazyVGrid(columns: columns) {
                    
                    
                    ForEach($model.fetchedImages){$imageAsset in
                        
                        GridContent(imageAsset: imageAsset)
                            .onAppear {
                                
                                if imageAsset.thumNail == nil{
                                    
                                    let manager = PHCachingImageManager.default()
                                    
                                    manager.requestImage(for: imageAsset.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                                        
                                        
                                        imageAsset.thumNail = image
                                    }
                                }
                            }
                        
                        
                        
                    }
                    
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                
                Button {
                    let imageAssets = model.selectedImages.compactMap { imageAsset -> PHAsset? in
                        
                        
                        return imageAsset.asset
                    }
                    onselect(imageAssets)
                    
                } label: {
                    
                    
                    Text("Add\(model.selectedImages.isEmpty ? "" : "\(model.selectedImages.count) Images")")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .padding(.horizontal,100)
                        .background(.blue,in: Capsule())
                    
                  
                    
                    
                    
                    
                    
                }

            }
            
        }
        .frame(height: deviceSize.height / 1.8)
        .frame(width: (deviceSize.width - 40) > 350 ? 350 : (deviceSize.width - 40))
        .background{
         
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(env.colorScheme == .dark ? .black : .white)
        }
        .frame(width: deviceSize.width, height: deviceSize.height)
    }
    @ViewBuilder
    func GridContent(imageAsset : ImageAsset)->some View{
        
        
        GeometryReader{proxy in
            
            let size = proxy.size
            
            ZStack{
                
                if let thmunail = imageAsset.thumNail{
                    
                    Image(uiImage: thmunail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                else{
                    
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                }
          
            
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(0.6))
                
                Circle()
                    .fill(.white.opacity(0.1))
                
                Circle()
                    .stroke(.white,lineWidth: 2)
                
                if let index =  model.selectedImages.firstIndex(where: { asset in
                    
                    asset.id == imageAsset.id
                    
                }){
                    
                    Circle()
                        .fill(.blue)
                    
                    Text("\(model.selectedImages[index].index + 1)")
                }
                
            }
            .frame(width: 20, height: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topTrailing)
            
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                
                withAnimation(.easeInOut){
                    
                    if let index = model.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }){
                        
                        model.selectedImages.remove(at: index)
                        model.selectedImages.enumerated().forEach { item in
                            
                            
                            model.selectedImages[item.offset].index = item.offset
                        }
                        
                        
                    }
                    else{
                        
                        var newAsset = imageAsset
                        newAsset.index = model.selectedImages.count
                        model.selectedImages.append(newAsset)
                    }
                }
            }
            
        }
        .frame(height: 70)
        
    }
}

struct PopupImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
