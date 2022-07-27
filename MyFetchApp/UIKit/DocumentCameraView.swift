//
//  DocumentCameraView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/23.
//

import Foundation
import VisionKit
import SwiftUI

struct DocumentCameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    @Binding var isShow: Bool
    var onCancel: (() -> Void)?
    var completion: ([UIImage]?,Error?) ->Void
    
    class Coordinator: NSObject,VNDocumentCameraViewControllerDelegate {
        let parent: DocumentCameraView
        
        init(_ parent: DocumentCameraView) {
            self.parent = parent
        }
        // 成功的回调
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var images: [UIImage] = []
            // 可能扫描了多张
            print("扫描到了\(scan.pageCount)页文档")
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                // 对图片进行后续的处理...
                images.append(image)
            }
            parent.completion(images,nil)
            parent.isShow = false
        }
        // 用户取消了
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            if let onCancel = parent.onCancel {
                onCancel()
            }
            parent.isShow = false
        }
        // 错误处理
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.completion(nil, error)
            parent.isShow = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
}
