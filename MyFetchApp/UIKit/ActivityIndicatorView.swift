//
//  ActivityIndicatorView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/7.
//

import UIKit
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    
    let style: UIActivityIndicatorView.Style
    let isAnimating: Bool
    
    init(_ style: UIActivityIndicatorView.Style = .medium,_ isAnimating: Bool = true) {
        self.style = style
        self.isAnimating = isAnimating
    }
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView()
        v.hidesWhenStopped = true
        v.style = style
        
        if isAnimating {
            v.startAnimating()
        }else {
            v.stopAnimating()
        }
        return v
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.style = style
        if isAnimating {
            uiView.startAnimating()
        }else {
            uiView.stopAnimating()
        }
    }
}
