//
//  MagnetView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI
import SwiftUIX
import ToastUI

struct MagnetView: View {
    
    @EnvironmentObject var store: Store
    
    @State var isShowPhotoLibrary = false
    @State var image: UIImage?
    @State var isShowDataScannerView = false
    
    var body: some View {
        VStack {
            HStack {
                MagnetViewButton(title: "从相册选择",color:.green) {
                    isShowPhotoLibrary.toggle()
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
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $image, encoding: nil) {
                print("取消了------")
                isShowPhotoLibrary = false
            }
        }
        .fullScreenCover(isPresented: $isShowDataScannerView, content: {
            ZStack(alignment: .topTrailing) {
                DataScannerView(isShow: $isShowDataScannerView, recognizedDataTypes: [.text(languages: ["en-US"])]) { scanString in
                    store.dispatch(.detectMagnetFrom(text: scanString))
                    isShowDataScannerView.toggle()
                }
                Button {
                    isShowDataScannerView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .offset(x: -20, y: 20)
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
        .hideTabView($store.appState.hideTabView)
    }
}

struct MagnetViewButton: View {
    let title: String
    let color: Color
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
        .background(color)
        .buttonStyle(BorderlessButtonStyle())
        .cornerRadius(8)
    }
}

struct MagnetView_Previews: PreviewProvider {
    static var previews: some View {
        MagnetView()
    }
}
