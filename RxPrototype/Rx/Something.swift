//
//  Something.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

extension ObservableType {

    func something() -> Observable {
        print("Something observing")
        return Something(self as? Observable)
    }

}

class Something: Observable {

    var observable: Observable?

    init(_ observable: Observable?) {
        print("Something created")
        self.observable = observable
    }

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("Something subscribing")
        return SomethingSink(observable, observer)
    }
    
}

class SomethingSink: Observer, ObservableSource {

    var source: ObservableSource?
    var observer: Observer?

    init(_ observable: Observable?, _ observer: Observer) {
        print("SomethingSink created")
        self.observer = observer
        self.source = observable?.subscribe(self)
    }

    deinit {
        print("SomethingSink deinit")
    }

    func run() {
        print("SomethingSink running")
        source?.run()
    }

    func on(_ event: Event) {
        print("SomethingSink on event \(event)")
        switch event {
        case .next(let value):
            if value > 0 { // We're doing something........
                forward(event)
            }
        case .completed, .error:
            forward(event)
            dispose()
        }
    }

    func forward(_ event: Event) {
        if let observer = observer {
            print("SomethingSink forwarding \(event)")
            observer.on(event)
        }
    }

    func dispose() {
        if source != nil {
            source?.dispose()
            source = nil
            observer = nil
            print("SomethingSink disposed")
        }
    }

}
