//
//  RxProtocols.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

enum Event {
    case next(Int)
    case completed
    case error
}

protocol ObservableSource: Disposable {
    func run()
}

protocol ObservableType {
    func subscribe(_ observer: Observer) -> ObservableSource
}

protocol Observable: ObservableType {

}

protocol Observer: ObserverType {

}

protocol ObserverType: class {
    func on(_ event: Event)
}

extension ObserverType {
    public func onNext(_ element: Int) {
        on(.next(element))
    }
    public func onCompleted() {
        on(.completed)
    }
    public func onError() {
        on(.error)
    }
}

