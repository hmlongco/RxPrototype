//
//  Just.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

extension ObservableType {

    static func just(_ value: Int) -> Observable {
        print("Just observing")
        return Just(value)
    }

}

class Just: Observable {

    var value: Int

    init(_ value: Int) {
        print("Just creating")
        self.value = value
    }

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("Just subscribing")
        return JustSource(observer, value)
    }

}

class JustSource: ObservableSource {

    var value: Int
    var observer: Observer?

    init(_ observer: Observer, _ value: Int) {
        print("JustSource created")
        self.observer = observer
        self.value = value
    }

    func run() {
        print("JustSource running")
        observer?.on(.next(value))
        observer?.on(.completed)
    }

    func dispose() {
        observer = nil
        print("JustSource disposed")
    }

}
