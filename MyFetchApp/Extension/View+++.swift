//
//  View+++.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/22.
//

import SwiftUI


// MARK: - 隐藏Tabbar

extension View {
    func hideTabView(_ hideTabView: Binding<Bool>) -> some View {
        self.modifier(HideTabViewModifier(hideTabView: hideTabView))
    }
}

struct HideTabViewModifier: ViewModifier {
    
    @Binding var hideTabView: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear { hideTabView = true }
            .onDisappear { hideTabView = false }
    }
}

// MARK: - 隐藏View

struct Show: ViewModifier {
    let isVisible: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if isVisible {
            content
        } else {
            content.hidden()
        }
    }
}

extension View {
    func isShow(isVisible: Bool) -> some View {
        self.modifier(Show(isVisible: isVisible))
    }
}

// MARK: - Branch

//    .if(colored) { view in
//      view.background(Color.blue)
//    }

extension View {
  @ViewBuilder
  func `if`<Transform: View>(_ condition: Bool, transform: (Self) ->  Transform) -> some View {
    if condition { transform(self) }
    else { self }
  }
}

// MARK: - Print

//self.Print("Inside ForEach", varOne, varTwo ...)

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

// MARK: - Size

//    .background(ReturnSize())

struct ReturnSize: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    print("geo \(geometry.size)")
                }
        }
    }
}

// MARK: - AnyView

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Shake

//    .onShake {  print("stop it shaking")}

extension NSNotification.Name {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: nil)
        }
     }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

// MARK: - 截图

//let image = textView.snapshot().ignoresSafeArea

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
//    利用新的 ImageRenderer API　輕鬆把 SwiftUI 視圖轉換為圖像
//https://www.appcoda.com.tw/imagerenderer-swiftui/
    @MainActor
    func generateSnapshot(scale: CGFloat?) -> UIImage {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
//https://developer.apple.com/documentation/swiftui/imagerenderer
    @MainActor
    func generatePDF(to renderURL: URL) {
        if let consumer = CGDataConsumer(url: renderURL as CFURL),
        let pdfContext = CGContext(consumer: consumer, mediaBox: nil, nil) {
            let renderer = ImageRenderer(content: self)
            renderer.render { size, renderer in
                let options: [CFString: Any] = [
                    kCGPDFContextMediaBox: CGRect(origin: .zero, size: size)
                ]
                pdfContext.beginPDFPage(options as CFDictionary)
                renderer(pdfContext)
                pdfContext.endPDFPage()
                pdfContext.closePDF()
            }
        }
    }
}

// MARK: - 给原视图的某一侧增加一个视图

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
