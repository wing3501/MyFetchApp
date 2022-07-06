//
//  MyQrCodeView.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/1.
//

import SwiftUI
import SwiftUIX

struct MyQrCodeView: View {
    
    @EnvironmentObject var store: Store
    @State var isShowPhotoLibrary = false
    
    var body: some View {
        Form {
            Section(header: "生成一个wifi连接二维码") {
                TextField("wifi名称", text: $store.appState.myQrCode.checker.wifiName)
                TextField("wifi密码", text: $store.appState.myQrCode.checker.wifiPassword)
            }
            
            Section(header: "二维码内容") {
                TextField("内容", text: $store.appState.myQrCode.qrcodeString)
                Toggle("二维码中心需要一张图片？", isOn: $isShowPhotoLibrary.onChange(isShowPhotoLibraryChanged))
                
                Button("生成二维码") {
                    store.dispatch(.createQrCode(qrCodeString: store.appState.myQrCode.qrcodeString))
                }
                .disabled(store.appState.myQrCode.qrcodeString.isEmpty)
                
                Button("重设") {
                    store.dispatch(.resetQrSetting)
                }

                Button("保存到相册") {
                    
                }
                .disabled(store.appState.myQrCode.qrCodeImage == nil)
                Button("分享") {
                    
                }
                .disabled(store.appState.myQrCode.qrCodeImage == nil)
            }
            
            Section(header: "效果预览") {
                QrCodePreviewView(qrCodeImage: store.appState.myQrCode.qrCodeImage)
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $store.appState.myQrCode.centerImage, encoding: nil) {
                print("取消了------")
                isShowPhotoLibrary = false
            }
        }
        .onSubmit {
            guard !store.appState.myQrCode.qrcodeString.isEmpty else { return }
            store.dispatch(.createQrCode(qrCodeString: store.appState.myQrCode.qrcodeString))
        }
    }
    
    func isShowPhotoLibraryChanged(_ value: Bool) {
        if !value {
            store.appState.myQrCode.centerImage = nil
        }
    }
}

struct QrCodePreviewView: View {
    let qrCodeImage: UIImage?
    
    var body: some View {
        ZStack {
            if let qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .frame(width: 300, height: 300)
                    .padding()
            }else {
                EmptyView()
            }
        }
    }
}

struct MyQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        MyQrCodeView()
    }
}
