//
//  UIImage++.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/19.
//

import UIKit

extension UIImage {
    // 鉴于 SwiftUI 提供的图片缩放 modifier 均会改变类型，缩放操作将使用 UIGraphicsImageRenderer 针对 UIImage 进行
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
