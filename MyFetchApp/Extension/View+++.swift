//
//  View+++.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI

extension View {
    /// 给原视图的某一侧增加一个视图
    func sideView<V: View>(sideView: V,position: Edge.Set? = .leading,
                  padding: CGFloat? = 8,
                  spacing: CGFloat? = nil,
                  viewClick: (() -> (Void))? = nil,
                  viewHidden:Binding<Bool>? = nil) -> some View {
        self.modifier(SideViewModifier(sideView: sideView, position: position, padding: padding, spacing: spacing, viewClick: viewClick, viewHidden: viewHidden))
    }
    
}



/// 给原视图的某一侧增加一个视图
struct SideViewModifier<V>: ViewModifier where V: View {
    /// 新增一侧视图
    let sideView: V
    /// 位置
    let position: Edge.Set
    /// 一侧视图的边距
    let padding: CGFloat
    /// 与原视图间距
    let spacing: CGFloat?
    /// 视图点击事件
    let viewClick: (() -> (Void))?
    /// 是否隐藏视图
    @Binding var viewHidden: Bool
    
    init(sideView: V,
         position: Edge.Set? = .leading,
         padding: CGFloat? = 8,
         spacing: CGFloat? = nil,
         viewClick: (() -> (Void))? = nil,
         viewHidden:Binding<Bool>? = nil) {
        
        self.sideView = sideView
        self.padding = padding ?? 8
        self.position = position ?? .leading
        self.spacing = spacing
        self.viewClick = viewClick
        self._viewHidden = viewHidden ?? .constant(false)
    }
    
    func body(content: Content) -> some View {
        
        if position == .leading || position == .trailing {
            HStack(alignment: .center, spacing: spacing) {
                if position == .leading {
                    placeSideView
                    content
                }else {
                    content
                    placeSideView
                }
            }
        }else {
            VStack(alignment: .center, spacing: spacing) {
                if position == .top {
                    placeSideView
                    content
                }else {
                    content
                    placeSideView
                }
            }
        }
    }
    
    var placeSideView: some View {
        Group {
            if viewHidden {
                EmptyView()
            }else {
                sideView
                    .padding(position,padding)
                    .onTapGesture {
                        if let viewClick = viewClick {
                            viewClick()
                        }
                    }
            }
        }
    }
}
