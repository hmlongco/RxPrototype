//
//  Disposable.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

protocol Disposable {
    func dispose()
}

class NopDisposable: Disposable {
    func dispose() {}
}

//class SubscriptionDisposable: Disposable {
//
//    var observable: ObservableType?
//
//    init(_ observable: ObservableType) {
//        print("SubscriptionDisposable created")
//        self.observable = observable
//    }
//
//    func dispose() {
//        print("SubscriptionDisposable disposed")
//        self.observable = nil
//    }
//
//}
