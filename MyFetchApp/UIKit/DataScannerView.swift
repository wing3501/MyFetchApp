//
//  DataScannerView.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/21.
//

import Foundation
import VisionKit
import SwiftUI

//struct DataScannerView: View {
//    @Binding var isShow: Bool
//    let recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType>
//    let tapOnItem: (String)->Void
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            DataScanner(isShow: $isShow, recognizedDataTypes: recognizedDataTypes, tapOnItem: tapOnItem)
//            Button {
//                isShow.toggle()
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//            }
//            .offset(x: -20, y: 20)
//        }
//    }
//}

struct DataScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DataScannerViewController
    
    @Binding var isShow: Bool
    let recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType>
    let tapOnItem: (String)->Void
    
    class Coordinator: NSObject,DataScannerViewControllerDelegate {
        let parent: DataScannerView
        
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            var scanString = ""
            
            switch item {
            case .text(let text):
                print("识别到：\(text.transcript)")
                scanString = text.transcript
//                let canditates = text.observation.topCandidates(10)
//                for canditate in canditates {
//                    print("识别到：\(canditate.string)")
//                    parent.resultArray.append(canditate.string)
//                }
            case .barcode(let barCode):
                if let payload = barCode.observation.payloadStringValue {
                    print("识别到：\(payload)")
                    scanString = payload
                }
            default: break
            }
            
            if !scanString.isEmpty {
                parent.tapOnItem(scanString)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScanner = DataScannerViewController(recognizedDataTypes: recognizedDataTypes, qualityLevel: .accurate, isHighlightingEnabled: true)
        dataScanner.delegate = context.coordinator
        return dataScanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if isShow {
            try? uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
        }
    }
    
    @MainActor static var dataScannerIsSupported: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
}
