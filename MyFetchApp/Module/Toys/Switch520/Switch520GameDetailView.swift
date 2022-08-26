//
//  Switch520GameDetailView.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/23.
//

import SwiftUI
import Kingfisher

struct Switch520GameDetailView: View {
    let title: String
    let imageUrl: String
    let downloadAdress: String
    let effectId: String
    let namespace: Namespace.ID
    let imageOnClick: ()-> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .foregroundColor(.black)
            KFImage(URL(string: "https://picsum.photos/300/200?aa=\(imageUrl)"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
                .matchedGeometryEffect(id: effectId, in: namespace)
                .onTapGesture {
                    withAnimation {
                        imageOnClick()
                    }
                }
            Text(downloadAdress)
                .font(.body)
                .foregroundColor(.gray)
            Spacer()
        }
        .background(.white)
    }
}

