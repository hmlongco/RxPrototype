//
//  Create.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

typealias SubscribeHandler = ((_ observer: ObserverType) -> Disposable)

extension ObservableType {

    static func create(_ subscribeHandler: @escaping (_ observer: ObserverType) -> Disposable) -> Observable {
        print("Create observing")
        return CreateProvider(subscribeHandler)
    }

}

fileprivate class CreateProvider: Observable {

    var subscribeHandler: SubscribeHandler

    init(_ subscribeHandler: @escaping SubscribeHandler) {
        print("Create creating")
        self.subscribeHandler = subscribeHandler
    }

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("Create subscribing")
        return CreateSource(observer, subscribeHandler)
    }

}

fileprivate class CreateSource: ObservableSource, ObserverType {

    var subscribeHandler: SubscribeHandler?
    var subscribeDisposable: Disposable? = nil
    var observer: Observer?

    init(_ observer: Observer, _ subscribeHandler: @escaping SubscribeHandler) {
        print("CreateSource created")
        self.observer = observer
        self.subscribeHandler = subscribeHandler
    }

    deinit {
        print("CreateSource deinit")
    }

    func run() {
        print("CreateSource running")
        subscribeDisposable = subscribeHandler?(self)
    }

    func on(_ event: Event) {
        print("CreateSource on event \(event)")
        switch event {
        case .next:
            forward(event)
        case .completed, .error:
            forward(event)
            dispose()
        }
    }

    func forward(_ event: Event) {
        if let observer = observer {
            print("CreateSource forwarding \(event)")
            observer.on(event)
        }
    }

    func dispose() {
        if observer != nil {
            observer = nil
            subscribeHandler = nil
            subscribeDisposable?.dispose()
            subscribeDisposable = nil
            print("CreateSource disposed")
        }
    }

}
