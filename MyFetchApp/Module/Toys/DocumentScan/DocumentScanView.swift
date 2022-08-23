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
    @State var isShowResults = false
    @State var image: UIImage?
    @State var scanResults: [String] = []
    
    var body: some View {
        VStack {
            Button {
                isShowCameraView.toggle()
            } label: {
                Text("扫描文档")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal,90)
            }
            .frame(height: 50)
            .background(.green)
            .buttonStyle(.borderless)
            .cornerRadius(8)
            
            if let image = image {
                Image(image: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
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
        .onChange(of: image, perform: detectText)
        .sheet(isPresented: $isShowResults, content: {
            DocumentResultView(texts: $scanResults)
                .ignoresSafeArea()
                .presentationDetents([.large,.height(300)])
                .presentationDragIndicator(.visible)
        })
        .toast(item: $store.appState.toastMessage, dismissAfter: 1.5) { toastString in
            ToastView(toastString)
        }
    }
    
    func detectText(_ image: UIImage?) -> Void {
        if let image {
            scanResults = VNDetectManager.shared.detectText(from: image, with: ["en-US","zh-Hans"])
            if !scanResults.isEmpty {
                delay(1) {
                    isShowResults = true
                }
            }
        }
    }
    
    struct DocumentResultView: View {
        @Binding var texts: [String]
        
        var body: some View {
            Text(text)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
        
        var text: String {
            return texts.joined(separator: "\n")
        }
    }
}

struct DocumentScanView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScanView()
    }
}
