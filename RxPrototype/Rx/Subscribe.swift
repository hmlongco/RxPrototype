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

fileprivate class SubscriptionSink: Observer, Disposable {

    var subscriptionHandler: ((_ event: Event) -> Void)?
    var source: ObservableSource?

    init(_ observable: Observable?, _ subscription: @escaping (_ event: Event) -> Void) {
        print("SubscriptionSink created")
        self.subscriptionHandler = subscription
        self.source = observable?.subscribe(self)
        self.source?.run()
    }

    deinit {
        print("SubscriptionSink deinit")
        dispose()
    }

    func on(_ event: Event) {
        print("SubscriptionSink on event \(event)")
        switch event {
        case .next:
            subscriptionHandler?(event)
        case .completed, .error:
            subscriptionHandler?(event)
            dispose()
        }
    }

    func dispose() {
        if source != nil {
            source?.dispose()
            source = nil
            subscriptionHandler = nil
            print("SubscriptionSink disposed")
        }
    }

}
