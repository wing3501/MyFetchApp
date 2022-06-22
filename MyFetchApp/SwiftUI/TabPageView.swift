//
//  TabPageView.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/27.
//

import SwiftUI

struct TabPageView<TabContent,PageContent,Data>: View where Data : RandomAccessCollection, Data.Index == Int ,TabContent : View,PageContent: View {
    let dataArray: Data
    let tab: (Data.Element,Int) -> TabContent
    let page: (Data.Element,Int) -> PageContent
    let tabHeight: CGFloat
    let pageHeight: CGFloat?
    let tabSpacing: CGFloat?
    let sliderHeight: CGFloat?
    
    @State var selectedTabIndexInside: Int = 0
    var selectedTabIndex: Binding<Int>?
    
    var selectedIndexBinding: Binding<Int> {
        selectedTabIndex ?? $selectedTabIndexInside
    }
    
    init(@ViewBuilder tab: @escaping (Data.Element,Int) -> TabContent,@ViewBuilder page: @escaping (Data.Element,Int) -> PageContent,dataArray: Data,selectedTabIndex: Binding<Int>? = nil,tabHeight: CGFloat? = 50,pageHeight: CGFloat? = nil,tabSpacing: CGFloat? = nil,sliderHeight: CGFloat? = nil) {
        self.tab = tab
        self.page = page
        self.dataArray = dataArray
        self.selectedTabIndex = selectedTabIndex
        self.tabHeight = tabHeight ?? 50
        self.pageHeight = pageHeight
        self.tabSpacing = tabSpacing
        self.sliderHeight = sliderHeight
    }
    
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    TabContentView(dataArray: dataArray, tab: tab, tabSpacing: tabSpacing, selectedTabIndex: selectedIndexBinding)
                    .overlayPreferenceValue(AnchorBoundsKey.self) { anchorValue in
                        if let sliderHeight = sliderHeight,let anchorValue = anchorValue {
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
//            .background(.random)
            .frame(height: tabHeight)
            
            PageContentView(dataArray: dataArray, page: page, selectedTabIndex: selectedIndexBinding)
                .frame(height: pageHeight)
            Spacer()
        }
    }
}

/// 分段选择器
struct TabContentView<Content,Data>: View where Data : RandomAccessCollection,Data.Index == Int ,Content : View {
    let dataArray: Data
    let tab: (Data.Element,Int) -> Content
    let tabSpacing: CGFloat?
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        LazyHStack(spacing: tabSpacing) {
            
            ForEach(0..<dataArray.count, id: \.self) { index in
                tab(dataArray[index],index)
                    .onTapGesture {
                        withAnimation {
                            selectedTabIndex = index
                        }
                    }
                    .anchorPreference(key: AnchorBoundsKey.self, value: .bounds, transform: { anchorValue in
                        selectedTabIndex == index ? anchorValue : nil
                    })
//                    .background(.random)
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
                .frame(width: proxy[anchor!].width, height: sliderHeight)
                .offset(x: proxy[anchor!].minX)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomLeading)
                .animation(.default, value: anchor)
        }
    }
}

/// 滚动page页
struct PageContentView<Content,Data>: View where Data : RandomAccessCollection,Data.Index == Int ,Content : View {
    let dataArray: Data
    let page: (Data.Element,Int) -> Content
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        TabView(selection: $selectedTabIndex.animation(.default)) {
            ForEach(0..<dataArray.count, id: \.self) { index in
                page(dataArray[index],index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .background(.random)
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
    var dataArray:[Int] = []
    var body: some View {
//        TabPageView(tab: { value in
//            Text("标题\(value)")
//        }, page: { value in
//            Text("内容\(value)")
//        }, dataArray: (0...20).map({$0}))

        TabPageView(tab: { value,index in
            Text("标题\(value)")
        }, page: { value,index in
            Text("内容\(value)")
        }, dataArray: dataArray)
    }
}
