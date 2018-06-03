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
//    var disposable: Disposable?
//
//    init(_ disposable: Disposable) {
//        print("SubscriptionDisposable created")
//        self.disposable = disposable
//    }
//
//    deinit {
//        print("SubscriptionDisposable deinit")
//        disposable?.dispose()
//        disposable = nil
//    }
//
//    func dispose() {
//        print("SubscriptionDisposable disposed")
//        disposable?.dispose()
//        disposable = nil
//    }
//
//}
