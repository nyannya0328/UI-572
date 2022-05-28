//
//  Extensions.swift
//  UI-572
//
//  Created by nyannyan0328 on 2022/05/28.
//

import SwiftUI
import PhotosUI




extension View{

    @ViewBuilder
    func popUpImagePicker(show : Binding<Bool>,transions : AnyTransition = .move(edge: .bottom),onSelect : @escaping([PHAsset]) -> ())-> some View{

           self
            .overlay {
                
                
                let deviceSize = UIScreen.main.bounds.size


                ZStack{


                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .opacity(show.wrappedValue ? 1 : 0)
                        .onTapGesture {
                            show.wrappedValue = false
                        }


                    if show.wrappedValue{

                        PopupImagePickerView {

                            show.wrappedValue = false

                        } onselect: { asset in

                            onSelect(asset)
                            show.wrappedValue = false

                        }

                    }
                }
                .frame(width: deviceSize.width, height: deviceSize.height)
                .animation(.spring(), value: show.wrappedValue)
                
                
            }
          
    }
}
