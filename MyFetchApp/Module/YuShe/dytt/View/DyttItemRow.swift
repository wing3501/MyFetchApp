//
//  DyttItemRow.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/2.
//

import SwiftUI
import Kingfisher

struct DyttItemRow: View {
    @State private var isExpanding = false
    let itemModel: DyttItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Text(itemModel.title)
                .font(.headline)
                .foregroundColor(.green)
//                .background(.random)
            Text(itemModel.subTitle)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(itemModel.desc)
                .font(.body)
                .foregroundColor(.blue)
////                .background(.random)
                .lineLimit(isExpanding ? nil : 1)
        }
//        .frame(height: isExpanding ? 220 : 60, alignment: .top)
//        .animation(.default, value: isExpanding)
        .onTapGesture {
//            withAnimation { //显式动画导致动画弹跳
                isExpanding.toggle()
//            }
        }
    }
}


struct DyttItemRow_Previews: PreviewProvider {
    static var previews: some View {
        DyttItemRow_Previews_ContentView()
    }
}

struct DyttItemRow_Previews_ContentView: View {
    @State var isExpanding = false
    var body: some View {
        List {
            DyttItemRow(itemModel: DyttItemModel(title: "2022年剧情爱情《我是真的讨厌异地恋》HD国语中字", subTitle: "日期：2022-06-02 19:05:53 点击：0", desc: "◎译 名 Stay with Me ◎片 名 我是真的讨厌异地恋 ◎年 代 2022 ◎产 地 中国大陆 ◎类 别 剧情/爱情 ◎语 言 普通话 ◎字 幕 中文 ◎上映日期 2022-04-29(中国大陆) ◎豆瓣评分 5.0/10 from 10927 users ◎片 长 108分钟 ◎导 演 吴洋 Yang Wu 周男燊 Nanshen Zhou", href: ""))
            DyttItemRow(itemModel: DyttItemModel(title: "2022年剧情爱情《我是真的讨厌异地恋》HD国语中字", subTitle: "日期：2022-06-02 19:05:53 点击：0", desc: "◎译 名 Stay with Me ◎片 名 我是真的讨厌异地恋 ◎年 代 2022 ◎产 地 中国大陆 ◎类 别 剧情/爱情 ◎语 言 普通话 ◎字 幕 中文 ◎上映日期 2022-04-29(中国大陆) ◎豆瓣评分 5.0/10 from 10927 users ◎片 长 108分钟 ◎导 演 吴洋 Yang Wu 周男燊 Nanshen Zhou", href: ""))
            DyttItemRow(itemModel: DyttItemModel(title: "2022年剧情爱情《我是真的讨厌异地恋》HD国语中字", subTitle: "日期：2022-06-02 19:05:53 点击：0", desc: "◎译 名 Stay with Me ◎片 名 我是真的讨厌异地恋 ◎年 代 2022 ◎产 地 中国大陆 ◎类 别 剧情/爱情 ◎语 言 普通话 ◎字 幕 中文 ◎上映日期 2022-04-29(中国大陆) ◎豆瓣评分 5.0/10 from 10927 users ◎片 长 108分钟 ◎导 演 吴洋 Yang Wu 周男燊 Nanshen Zhou", href: ""))
        }
    }
}

