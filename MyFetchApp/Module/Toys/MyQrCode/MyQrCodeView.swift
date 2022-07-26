//
//  MyQrCodeView.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/1.
//

import SwiftUI
import SwiftUIX
import ToastUI
import PhotosUI

struct MyQrCodeView: View {
    
    @EnvironmentObject var store: Store
    @State var isShowPhotoLibrary = false
    @State var hasCenterImage = false
    @FocusState private var focusedField: MyQrCodeField?
    
    enum MyQrCodeField {
        case wifiName
        case wifiPassword
        case qrContent
    }
    
    var body: some View {
        Form {
            Section(header: "生成一个wifi连接二维码") {
                TextField("wifi名称", text: $store.appState.myQrCode.checker.wifiName)
                    .focused($focusedField, equals: .wifiName)
                    .submitLabel(.next)
                TextField("wifi密码", text: $store.appState.myQrCode.checker.wifiPassword)
                    .focused($focusedField, equals: .wifiPassword)
                    .submitLabel(.done)
            }
            
            Section(header: "二维码内容") {
                TextField("内容", text: $store.appState.myQrCode.qrcodeString)
                    .focused($focusedField, equals: .qrContent)
                    .submitLabel(.done)
                
                Toggle("二维码中心需要一张图片？", isOn: $hasCenterImage.onChange({ hasCenter in
                    focusedField = nil
                    if(hasCenter) {
                        isShowPhotoLibrary = true
                    }else {
                        store.dispatch(.cleanQrCenterImage)
                        if let _ = store.appState.myQrCode.qrCodeImage {
                            store.dispatch(.createQrCode(qrCodeString: store.appState.myQrCode.qrcodeString))
                        }
                    }
                }))
                
                Button("生成二维码") {
                    focusedField = nil
                    store.dispatch(.createQrCode(qrCodeString: store.appState.myQrCode.qrcodeString))
                }
                .disabled(store.appState.myQrCode.qrcodeString.isEmpty)
                
                Button("重设") {
                    focusedField = nil
                    store.dispatch(.resetQrSetting)
                }
                .foregroundColor(.red)
            }
            
            Section(header: "效果预览(长按分享、保存)") {
                QrCodePreviewView(qrCodeImage: store.appState.myQrCode.qrCodeImage)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $store.appState.myQrCode.centerImage, encoding: nil) {
                hasCenterImage = false
                isShowPhotoLibrary = false
            }
        }
        .onSubmit {
            switch focusedField {
            case .wifiName:
                focusedField = .wifiPassword
            default:
                focusedField = nil
                guard !store.appState.myQrCode.qrcodeString.isEmpty else { return }
                store.dispatch(.createQrCode(qrCodeString: store.appState.myQrCode.qrcodeString))
            }
        }
        .toast(item: $store.appState.toastMessage, dismissAfter: 1) { toastString in
            ToastView(toastString)
        }
        .scrollDismissesKeyboard(.automatic)
    }
}

struct QrCodePreviewView: View {
    @EnvironmentObject var store: Store
    let qrCodeImage: UIImage?
    let qrImage: Image? = nil
    
    var body: some View {
        ZStack {
            if let qrCodeImage,let qrImage = Image(uiImage: qrCodeImage) {
                qrImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
                    .contextMenu {
                        Button {
                            store.dispatch(.saveToAlbum(image: qrCodeImage))
                        } label: {
                            Label("保存到相册") {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .foregroundStyle(.green, .cyan)
                            }
                        }
                        
                        ShareLink(item: qrImage, preview: SharePreview("二维码", image: qrImage)) {
                            Label("分享", systemImage:  "square.and.arrow.up")
                        }
                    }
            }else {
                Text("暂未生成")
                    .foregroundColor(.green)
            }
        }
    }
}

struct MyQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        MyQrCodeView()
    }
}
