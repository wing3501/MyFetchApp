//
//  TabPageView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/27.
//

import SwiftUI

struct TabPageView<Tab,Page>: View where Tab: View, Page: View {
    
    let tabs: [Tab]
    let pages: [Page]
    let tabHeight: CGFloat
    let pageHeight: CGFloat?
    let tabSpacing: CGFloat?
    let sliderHeight: CGFloat?
    
    @State var selectedTabIndexInside: Int = 0
    var selectedTabIndex: Binding<Int>?
    
    var selectedIndexBinding: Binding<Int> {
        selectedTabIndex ?? $selectedTabIndexInside
    }
    
    init(tabs: [Tab],pages: [Page],selectedTabIndex: Binding<Int>? = nil,tabHeight: CGFloat? = 50,pageHeight: CGFloat? = nil,tabSpacing: CGFloat? = nil,sliderHeight: CGFloat? = nil) {
        self.tabs = tabs
        self.pages = pages
        self.selectedTabIndex = selectedTabIndex
        self.tabHeight = tabHeight ?? 50
        self.pageHeight = pageHeight
        self.tabSpacing = tabSpacing
        self.sliderHeight = sliderHeight
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    TabContentView(views: tabs, tabSpacing: tabSpacing, selectedTabIndex: selectedIndexBinding)
                    .overlayPreferenceValue(AnchorBoundsKey.self) { anchorValue in
                        if let sliderHeight = sliderHeight {
                            TabSlider(anchor: anchorValue,sliderHeight: sliderHeight)
                        }
                    }
                    .onChange(of: selectedIndexBinding.wrappedValue) { newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .background(.yellow)
            .frame(height: tabHeight)
            
            PageContentView(views: pages, selectedTabIndex: selectedIndexBinding)
                .frame(height: pageHeight)
            Spacer()
        }
    }
}

/// 分段选择器
struct TabContentView<Content>: View where Content: View {
    let views: [Content]
    let tabSpacing: CGFloat?
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        LazyHStack(spacing: tabSpacing) {
            ForEach(0..<views.count, id: \.self) { index in
                views[index]
                    .onTapGesture {
                        withAnimation {
                            selectedTabIndex = index
                        }
                    }
                    .anchorPreference(key: AnchorBoundsKey.self, value: .bounds, transform: { anchorValue in
                        selectedTabIndex == index ? anchorValue : nil
                    })
                    .background(.random)
                    .id(index)
            }
        }
    }
}

/// 滑块
struct TabSlider: View {
    var anchor: Anchor<CGRect>?
    let sliderHeight: CGFloat?
    
    var body: some View {
        return GeometryReader { proxy in
            Rectangle()
                .fill(.blue)
                .frame(width: proxy[anchor!].width, height: 2)
                .offset(x: proxy[anchor!].minX)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomLeading)
                .animation(.default, value: anchor)
        }
    }
}

/// 滚动page页
struct PageContentView<Page>: View where Page: View {
    let views: [Page]
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        TabView(selection: $selectedTabIndex.animation(.default)) {
            ForEach(0..<views.count, id: \.self) { index in
                views[index]
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(.random)
    }
}

struct AnchorBoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

struct TabPageView_Previews: PreviewProvider {
    static var previews: some View {
        TabPageView_Previews_TempView()
    }
}

struct TabPageView_Previews_TempView: View {
    @State var selectedTabIndex: Int = 3
    let tabs = (0...20).map { value in
        Text("标题\(value)")
    }
    let pages = (0...20).map { value in
        Text("内容\(value)")
    }
    var body: some View {
//        TabPageView(tabs: tabs, pages: pages,selectedTabIndex: $selectedTabIndex)
        TabPageView(tabs: tabs, pages: pages)
    }
}
