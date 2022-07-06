//
//  UIImageHelper.swift
//  MyFetchApp
//
//  Created by styf on 2022/7/1.
//  https://www.jianshu.com/p/81e125a04cae

import UIKit
import CoreImage


class UIImageHelper {
    static let shared = UIImageHelper()
    
    //!< L: 7%
    //!< M: 15%
    //!< Q: 25%
    //!< H: 30%
    enum QRHnputCorrectionLevel: String {
        case L,M,Q,H
    }
    
    /// 从字符串生成一个二维码
    /// - Parameters:
    ///   - content: 字符串内容
    ///   - centerImage: 中心图片
    ///   - size: 尺寸
    /// - Returns: 二维码图片
    func qrCode(from content: String,size: CGSize ,centerImage: UIImage? = nil) -> UIImage? {
        // 1.创建一个二维码滤镜实例
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        // 2.给滤镜添加数据
        guard let data = content.data(using: .utf8) else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(QRHnputCorrectionLevel.H.rawValue, forKey: "inputCorrectionLevel")
        // 3.生成二维码
        guard let ciimage = filter.outputImage else { return nil }
        
        // 由filter.outputImage直接转成的UIImage不太清楚，需要做高清处理
        guard let image = scale(ciimage: ciimage, to: size) else { return nil }
        if let logo = centerImage {
            return qrCode(qrCodeImage: image, logoImage: logo)
        }
        return image
    }
    
    /// 给二维码图片添加logo
    /// - Parameters:
    ///   - qrCodeImage: 二维码图片
    ///   - logoImage: logo图片
    /// - Returns: 合并后的图片
    private func qrCode(qrCodeImage: UIImage, logoImage: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(qrCodeImage.size, true, UIScreen.main.scale)
        
        // 将codeImage画到上下文中
        qrCodeImage.draw(in: CGRect(x: 0, y: 0, width: qrCodeImage.size.width, height: qrCodeImage.size.height))
        // 定义logo的绘制参数
        let logoSide = CGFloat(fminf(Float(qrCodeImage.size.width), Float(qrCodeImage.size.height)) / 4);
        let logoX = (qrCodeImage.size.width - logoSide) / 2;
        let logoY = (qrCodeImage.size.height - logoSide) / 2;
        let logoRect = CGRect(x: logoX, y: logoY, width: logoSide, height: logoSide)
        
        let cornerPath = UIBezierPath(roundedRect: logoRect, cornerRadius: logoSide / 5)
        cornerPath.lineWidth = 2.0
        UIColor.white.set()
        cornerPath.stroke()
        cornerPath.addClip()
        
        // 将logo画到上下文中
        logoImage.draw(in: logoRect)
        
        // 从上下文中读取image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 生成条形码
    /// - Parameters:
    ///   - content: 内容
    ///   - size: 尺寸
    /// - Returns: 图片
    func code128(from content: String, size: CGSize) -> UIImage? {
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        filter.setDefaults()
        guard let data = content.data(using: .utf8) else { return nil }
//    为filter设置input参数：inputMessage: 要生成的条形码数据，inputQuietSpace: 条形码留白距离，inputBarcodeHeight: 条形码高度；
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(0.0, forKey: "inputQuietSpace")
        guard let ciimage = filter.outputImage else { return nil }
        return scale(ciimage: ciimage, to: size)
    }
    
    /// 图片高清化
    /// - Parameters:
    ///   - ciimage: 图片
    ///   - size: 尺寸
    /// - Returns: 高清化之后的图片
    func scale(ciimage: CIImage, to size: CGSize) -> UIImage? {
        // 将CIImage转成CGImageRef
        let integralRect = CGRectIntegral(ciimage.extent) // 将rect取整后返回，origin取舍，size取入
        guard let imageRef = CIContext().createCGImage(ciimage, from: integralRect) else { return nil }
        
        //创建上下文
        let sideScale = fminf(Float(size.width / integralRect.size.width), Float(size.width / integralRect.size.height)) * Float(UIScreen.main.scale)// 计算需要缩放的比例
        
        let contextRefWidth = ceilf(Float(integralRect.size.width) * sideScale)
        let contextRefHeight = ceilf(Float(integralRect.size.height) * sideScale)
        guard let contextRef = CGContext(data: nil, width: Int(contextRefWidth), height: Int(contextRefHeight), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil } // 灰度、不透明
        
        contextRef.interpolationQuality = .none //设置上下文无插值
        contextRef.scaleBy(x: CGFloat(sideScale), y: CGFloat(sideScale)) //设置上下文缩放
        contextRef.draw(imageRef, in: integralRect)// 在上下文中的integralRect中绘制imageRef
        
        //从上下文中获取CGImageRef
        guard let scaledImageRef = contextRef.makeImage() else { return nil }
        
        return UIImage(cgImage: scaledImageRef, scale: UIScreen.main.scale, orientation: .up)
    }
    
}
