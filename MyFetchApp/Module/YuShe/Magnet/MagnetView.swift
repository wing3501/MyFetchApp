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
    
//    @EnvironmentObject var store: Store
    
    @State var isShowPhotoLibrary = false
    @State var image: UIImage?
    @State var isShowToastString: String?
    
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
                    
//                    等iOS16,直接用 DataScannerViewController
                    isShowToastString = "别问，问就是等iOS16"
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
        .toast(item: $isShowToastString, dismissAfter: 2.0) { toastString in
            ToastView(toastString)
        }
//            .hideTabView($store.appState.hideTabView)
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
