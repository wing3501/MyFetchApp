//
//  VNDetectManager.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import Foundation
import Vision
import UIKit

class VNDetectManager {
    static let shared = VNDetectManager()
    
    func detectTextWithEn(from image: UIImage) -> [String] {
        detectText(from: image, with: "en-US")
    }
    
    func detectTextWithZh(from image: UIImage) -> [String] {
        detectText(from: image, with: "zh-Hans")
    }
    
    private func detectText(from image: UIImage, with language: String) -> [String] {
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
            textRequest.recognitionLanguages = [language]
            
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
}
