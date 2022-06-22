//
//  MagnetView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI
import SwiftUIX

struct MagnetView: View {
    
//    @EnvironmentObject var store: Store
    
    @State var isShowPhotoLibrary = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            HStack {
                MagnetViewButton(title: "从相册选择") {
                    isShowPhotoLibrary.toggle()
                }
                MagnetViewButton(title: "扫一扫") {
                    
                }
            }
            .padding()
            .padding(.top,80)
            GroupBox("结果如下(点击可复制)：") {
                VStack(alignment: .leading) {
                    Text("Username: tswift89")
                    Text("City: Nashville")
                    GroupBox {
                        if let _ = image {
                            Text("图片有值")
                        }else {
                            Text("图片为空")
                        }
                        
                    }
                }
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $image, encoding: nil) {
                print("取消了------")
            }
        }
//            .hideTabView($store.appState.hideTabView)
    }
}

struct MagnetViewButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(.green)
        .buttonStyle(BorderlessButtonStyle())
        .cornerRadius(8)
    }
}

struct MagnetView_Previews: PreviewProvider {
    static var previews: some View {
        MagnetView()
    }
}
