//
//  Defaults.swift
//  MyFetchApp
//
//  Created by styf on 2022/5/30.
//

import Foundation
import SwiftUI
/*
 @AppStorage 研究 https://fatbobman.com/posts/appstorage/
@Default(\.name) var name
Text(name)
TextField("name",text:$name)
*/

public class Defaults: ObservableObject {
//    @AppStorage("name") public var name = "fatbobman"
    public static let shared = Defaults()
}

@propertyWrapper
public struct Default<T>: DynamicProperty {
    @ObservedObject private var defaults: Defaults
    private let keyPath: ReferenceWritableKeyPath<Defaults, T>
    
    public init(_ keyPath: ReferenceWritableKeyPath<Defaults, T>, defaults: Defaults = .shared) {
        self.keyPath = keyPath
        self.defaults = defaults
    }
    
    public var wrappedValue: T {
        get { defaults[keyPath: keyPath] }
        nonmutating set { defaults[keyPath: keyPath] = newValue }
    }
    
    public var projectedValue: Binding<T> {
        Binding(
            get: { defaults[keyPath: keyPath] },
            set: { value in
                defaults[keyPath: keyPath] = value
            }
        )
    }
}

