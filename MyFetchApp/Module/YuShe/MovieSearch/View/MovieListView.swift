//
//  MovieListView.swift
//  MyFetchApp
//
//  Created by styf on 2022/6/15.
//

import SwiftUI
import Kingfisher

struct MovieListView: View {
    
    let movies: [MovieResult]
    
    var body: some View {
        List(movies) { movie in
            NavigationLink(value: movie) {
                MovieListRow(movie: movie)
            }
        }
        .navigationDestination(for: MovieResult.self) { movie in
            MovieDetailView(url: movie.href)
        }
    }
}

struct MovieListRow: View {
    let movie: MovieResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            KFImage(URL(string: movie.image))
                .onSuccess({ r in
//                    print("KFImage Success \(r)")
                })
                .onFailure({ e in
                    print("KFImage Failure \(e)")
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .clipped()
            VStack(alignment: .leading, spacing: 5, content: {
                Text(movie.title)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                ForEach(movie.other, id: \.self) { desc in
                    Text(desc)
                }
            })
//                .background(.random)
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .listRowSeparator(.hidden)
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movies: [MovieResult.example,MovieResult.example,MovieResult.example])
    }
}
