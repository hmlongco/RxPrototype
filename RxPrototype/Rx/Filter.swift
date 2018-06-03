//
//  Filter.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

extension ObservableType {

    func filter(_ predicate: @escaping (_ value: Int) -> Bool) -> Observable {
        print("Filter observing")
        return FilterProvider(self as? Observable, predicate)
    }

}

fileprivate class FilterProvider: Observable {

    var predicate: ((_ value: Int) -> Bool)
    var observable: Observable?

    init(_ observable: Observable?, _ predicate: @escaping (_ value: Int) -> Bool) {
        print("Filter created")
        self.predicate = predicate
        self.observable = observable
    }

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("Filter subscribing")
        return FilterSink(observable, observer, predicate)
    }

}

fileprivate class FilterSink: ObservableSink {

    var predicate: ((_ value: Int) -> Bool)?

    init(_ observable: Observable?, _ observer: Observer, _ predicate: @escaping (_ value: Int) -> Bool) {
        print("FilterSink created")
        self.predicate = predicate
        super.init(observable, observer)
    }

    deinit {
        print("FilterSink deinit")
    }

    override func on(_ event: Event) {
        print("FilterSink on event \(event)")
        switch event {
        case .next(let value):
            if let predicate = predicate, predicate(value) {
                print("FilterSink forwarding event \(event)")
                forward(event)
            }
        case .completed, .error:
            print("FilterSink forwarding event \(event)")
            forward(event)
            dispose()
        }
    }

    override func dispose() {
        super.dispose()
        predicate = nil
        print("FilterSink disposed")
    }

}
