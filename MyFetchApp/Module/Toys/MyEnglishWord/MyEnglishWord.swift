//
//  MyEnglishWord.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/31.
//

import SwiftUI

struct MyEnglishWord: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                Task {
                    let val = await EnglishTranslateRequest.baiduTranslate("One")
                    print("\(val)")
                    
                    await EnglishTranslateRequest.bingWebTranslate("go to")
                }
            }
            .task {
//                let val = await EnglishTranslateRequest.baiduTranslate("One")
//                print("\(val)")
                
                await EnglishTranslateRequest.bingWebTranslate("apple")
                print("---------------")
                await EnglishTranslateRequest.bingWebTranslate("go to")
            }
    }
}

struct MyEnglishWord_Previews: PreviewProvider {
    static var previews: some View {
        MyEnglishWord()
    }
}
