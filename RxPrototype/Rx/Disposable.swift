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
//    var subscription: SubscriptionSink?
//
//    init(_ subscription: SubscriptionSink) {
//        print("SubscriptionDisposable created")
//        self.subscription = subscription
//    }
//
//    func dispose() {
//        print("SubscriptionDisposable disposed")
//        subscription?.dispose()
//        subscription = nil
//    }
//
//}
