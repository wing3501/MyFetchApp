//
//  Switch520GameItemView.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/10.
//

import SwiftUI
import Kingfisher

struct Switch520GameItemView: View {
    let title: String
    let imageUrl: String
    let category: [String]
    let datetime: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            KFImage(URL(string: item.imageUrl)) //对方把图床换了
            KFImage(URL(string: "https://picsum.photos/300/200?aa=\(imageUrl)"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()
            GameItemTagView(category: category)
            Text(title)
                .foregroundColor(.white)
                .lineLimit(2...2)
                .font(Font.system(size: 15), weight: .bold)
                .padding(.leading, 8)
            Text(datetime)
                .foregroundColor(.gray)
                .font(Font.system(size: 10))
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 12, trailing: 0))
        }
        .background(.black)
        .cornerRadius(10)
//        .frame(width: 250)
    }
}

struct GameItemTagView: View {
    let category: [String]
    let colors: [Color] = [.orange,.green,.blue,.purple,.pink]
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(category.indices, id: \.self) { index in
                Label {
                    Text(category[index])
                        .font(Font.system(size: 10))
                        .foregroundColor(.white)
                        .offset(x: -2)
                } icon: {
                    Circle()
                        .fill(colors[index])
                        .frame(width: 8, height: 8)
                }
            }
        }
//        .background(.yellow)
        .padding(.horizontal, 8)
    }
}

struct Switch520GameItemView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Switch520Game.example
        Switch520GameItemView(title: item.title, imageUrl: item.imageUrl, category: item.category, datetime: item.datetime)
    }
}
