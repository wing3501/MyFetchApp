//
//  MagnetView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI
import ToastUI
import PhotosUI

struct MagnetView: View {
    
    @EnvironmentObject var store: Store
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
   
    @State var image: UIImage?
    @State var isShowDataScannerView = false
    
    var body: some View {
        VStack {
            HStack {
                //How to Use the SwiftUI PhotosPicker
                //https://swiftsenpai.com/development/swiftui-photos-picker/?utm_source=rss&utm_medium=rss&utm_campaign=swiftui-photos-picker
                
                PhotosPicker(selection: $selectedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                    MagnetViewButton(title: "从相册选择",color: .green)
                }
                
                MagnetViewButton(title: "扫一扫",color:.red) {
//                    【WWDC22 10025】VisionKit 的机器视觉方案，更智能的捕获文本与条码
//                https://xiaozhuanlan.com/topic/8205316479
//                    【WWDC21 10041】使用 Vision 提取文档里的数据
//                https://xiaozhuanlan.com/topic/6204139578
//                    在 SwiftUI 利用 Live Text API　從圖片中擷取文本
//                https://www.appcoda.com.tw/live-text-api/
                    
                    isShowDataScannerView.toggle()
                }
                .disabled(!DataScannerView.dataScannerIsSupported)
            }
            .padding()
            .padding(.top,80)
            GroupBox("可能的结果如下(点击可复制)：") {
                VStack(alignment: .leading) {
                    VStack {
                        ForEach(store.appState.magnetState.magnetLinks) { link in
                            Text(link)
                                .onTapGesture {
                                    store.dispatch(.updatePasteboardText(content: link))
                                }
                        }
                    }
                }
            }
            .padding()
            Spacer()
        }
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: selectedItem, perform: { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiimage = UIImage(data: data){
                   image = uiimage
                }
            }
        })
        .fullScreenCover(isPresented: $isShowDataScannerView, content: {
            DataScannerView(isShow: $isShowDataScannerView, recognizedDataTypes: [.text(languages: ["en-US"])]) { scanString in
                store.dispatch(.detectMagnetFrom(text: scanString))
                isShowDataScannerView.toggle()
            }
        })
        .toast(item: $store.appState.toastMessage, dismissAfter: 1.5) { toastString in
            ToastView(toastString)
        }
        .toast(isPresented: $store.appState.toastLoading, content: {
            ToastView(store.appState.toastLoadingMessage)
                .toastViewStyle(.indeterminate)
        })
        .onChange(of: image) { img in
            if let img = img {
                store.dispatch(.detectMagnet(image: img))
            }
        }
    }
}

struct MagnetViewButton: View {
    let title: String
    let color: Color
    var action: (() -> Void)? = nil
    
    var body: some View {
        content
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(color)
        .buttonStyle(BorderlessButtonStyle())
        .cornerRadius(8)
    }
    
    var text: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    var content: some View {
        Group {
            if let action {
                Button {
                    action()
                } label: {
                    text
                }
            }else {
                text
            }
        }
    }
    
}

struct MagnetView_Previews: PreviewProvider {
    static var previews: some View {
        MagnetView()
    }
}
