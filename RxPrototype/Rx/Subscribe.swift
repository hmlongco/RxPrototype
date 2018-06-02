//
//  Subscribe.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

extension ObservableType {

    func subscribe(on subscription: @escaping (_ event: Event) -> Void) -> Disposable {
        print("SubscriptionSink subscribing")
        return SubscriptionSink(self as? Observable, subscription)
    }

}

class SubscriptionSink: Observer, Disposable {

    var subscription: ((_ event: Event) -> Void)?
    var disposable: Disposable?

    init(_ observable: Observable?, _ subscription: @escaping (_ event: Event) -> Void) {
        print("SubscriptionSink created")
        self.subscription = subscription
        self.disposable = observable as? Disposable
        _ = observable?.subscribe(self)
    }

    deinit {
        print("SubscriptionSink deinit")
    }

    func on(_ event: Event) {
        print("SubscriptionSink on event \(event)")
        switch event {
        case .next:
            subscription?(event)
        case .completed, .error:
            subscription?(event)
            dispose()
        }
    }

    func dispose() {
        subscription = nil
        disposable?.dispose()
        disposable = nil
        print("SubscriptionSink disposed")
    }

}
