//
//  DocumentScanView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/23.
//  【WWDC21 10041】使用 Vision 提取文档里的数据
//   https://xiaozhuanlan.com/topic/6204139578

import SwiftUI
import ToastUI

struct DocumentScanView: View {
    
    @EnvironmentObject var store: Store
    @State var isShowCameraView = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            Button {
                isShowCameraView.toggle()
            } label: {
                Text("扫描文档")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal,90)
            .frame(height: 50)
            .background(.green)
            .buttonStyle(BorderlessButtonStyle())
            .cornerRadius(8)
            
            if let image = image {
                Image(image: image)
                    .resizable()
                    .frame(width: 300)
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isShowCameraView) {
            DocumentCameraView(isShow: $isShowCameraView) { images, error in
                if let error = error {
                    store.appState.toastMessage = "识别出错:\(error.localizedDescription)"
                }
                if let images = images {
                    image = images.first
                }
            }
        }
        .toast(item: $store.appState.toastMessage, dismissAfter: 1.5) { toastString in
            ToastView(toastString)
        }
    }
}

struct DocumentScanView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScanView()
    }
}
