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
                    
                if let _ = store.appState.myQrCode.centerImage {
                    Toggle("二维码中心需要一张图片？", isOn: .constant(true))
                }else {
                    Toggle("二维码中心需要一张图片？", isOn: $isShowPhotoLibrary)
                }
                
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
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(image: $store.appState.myQrCode.centerImage, encoding: nil) {
                print("取消了------")
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
        .scrollDismissesKeyboard(.automatic)
    }
}

struct QrCodePreviewView: View {
    let qrCodeImage: UIImage?
    
    var body: some View {
        ZStack {
            if let qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
                    .contextMenu {
                        Button {
                            print("Change country setting")
                        } label: {
                            Label("Choose Country", systemImage: "globe")
                        }

                        Button {
                            print("Enable geolocation")
                        } label: {
                            Label("Detect Location", systemImage: "location.circle")
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
