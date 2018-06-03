//
//  Subscribe.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

typealias SubscriptionHandler = (_ event: Event) -> Void

extension ObservableType {

    func subscribe(on subscription: @escaping SubscriptionHandler) -> Disposable {
        print("SubscriptionSink subscribing")
        return SubscriptionSink(self as? Observable, subscription)
    }

}

fileprivate class SubscriptionSink: Sink {

    var subscriptionHandler: SubscriptionHandler?

    init(_ observable: Observable?, _ subscription: @escaping (_ event: Event) -> Void) {
        print("SubscriptionSink created")
        self.subscriptionHandler = subscription
        super.init(observable)
        self.source?.run()
    }

    deinit {
        print("SubscriptionSink deinit")
    }

    override func on(_ event: Event) {
        print("SubscriptionSink on event \(event)")
        switch event {
        case .next:
            subscriptionHandler?(event)
        case .completed, .error:
            subscriptionHandler?(event)
            dispose()
        }
    }

    override func dispose() {
        super.dispose()
        subscriptionHandler = nil
        print("SubscriptionSink disposed")
    }

}
