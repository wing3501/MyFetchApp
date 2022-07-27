//
//  VNDetectManager.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import Foundation
import Vision
import UIKit
import ImageIO
import VisionKit

class VNDetectManager {
    static let shared = VNDetectManager()
    
    func detectTextWithEn(from image: UIImage) -> [String] {
        detectText(from: image, with: ["en-US"])
    }
    
    func detectTextWithZh(from image: UIImage) -> [String] {
        detectText(from: image, with: ["zh-Hans"])
    }
    
    /// 从图片上识别二维码
    /// - Parameter image: 图片
    /// - Returns: 二维码信息数组
    func detectQrCode(from image: UIImage) -> [String] {
        
        guard let cgimage = image.cgImage else { return [] }
        
        let barcodesRequest = VNDetectBarcodesRequest()
        barcodesRequest.revision = VNDetectBarcodesRequestRevision2
        barcodesRequest.symbologies = [.qr]
        
        let requestHandler = VNImageRequestHandler(cgImage: cgimage, options: [:])
        // 开始识别、检测
        try? requestHandler.perform([barcodesRequest])
        
        var resultArray: [String] = []
        if let results = barcodesRequest.results {
            for observation in results {
                if let payload = observation.payloadStringValue {
                    resultArray.append(payload)
                }
            }
        }
        return resultArray
    }
    
    /// 从图片上检测文字信息
    /// - Parameters:
    ///   - image: 图片
    ///   - language: 语言
    /// - Returns: 文字数据
    func detectText(from image: UIImage, with language: [String]) -> [String] {
        var resultStringArray: [String] = []
        if let cgimage = image.cgImage {
            let textRequest = VNRecognizeTextRequest()
            
            textRequest.revision = VNRecognizeTextRequestRevision2
            // 设置工作模式 .fast 或者 .accurate
            textRequest.recognitionLevel = .accurate
            // 是否启用语言矫正
            textRequest.usesLanguageCorrection = false
            // 查看支持的语言
    //        let supportLanauages = try? textRequest.supportedRecognitionLanguages() // iOS 15才有的api
            // ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant"]
            textRequest.recognitionLanguages = language
            
            // 使用correctedImage创建新的handler
            let requestHandler = VNImageRequestHandler(cgImage: cgimage, options: [:])
            
            // 开始识别、检测
            try? requestHandler.perform([textRequest])
            
            if let results = textRequest.results {
                for observation in results {
                    let canditates = observation.topCandidates(10)
                    for canditate in canditates {
                        resultStringArray.append(canditate.string)
                    }
                }
            }
        }
        return resultStringArray
    }
    
    /// 识别图片上的文档区域
    /// - Parameter image: 图片
    /// - Returns: 结果
    func recognize(image: UIImage) -> VNRectangleObservation? {
        guard let ciImage = image.ciImage ?? CIImage(image: image) else {
            print("创建ciimage失败!")
            return nil
        }
                
        let documentSegmentationHandler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation(image.imageOrientation), options: [:])
        let documentSegmentationRequest = VNDetectDocumentSegmentationRequest()
        documentSegmentationRequest.revision = VNDetectDocumentSegmentationRequestRevision1
        try? documentSegmentationHandler.perform([documentSegmentationRequest])
        
        guard let result = documentSegmentationRequest.results?.first, result.confidence > 0.7 else {
            print("未检测到文档")
            return nil
        }
        return result
    }
}
