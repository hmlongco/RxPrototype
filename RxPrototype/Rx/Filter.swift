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
        return Filter(self as? Observable, predicate)
    }

}

fileprivate class Filter: Observable {

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

fileprivate class FilterSink: Observer, ObservableSource {

    var predicate: ((_ value: Int) -> Bool)?
    var source: ObservableSource?
    var observer: Observer?

    init(_ observable: Observable?, _ observer: Observer, _ predicate: @escaping (_ value: Int) -> Bool) {
        print("FilterSink created")
        self.predicate = predicate
        self.observer = observer
        self.source = observable?.subscribe(self)
    }

    deinit {
        print("FilterSink deinit")
    }

    func run() {
        print("FilterSink running")
        source?.run()
    }

    func on(_ event: Event) {
        print("FilterSink on event \(event)")
        switch event {
        case .next(let value):
            if let predicate = predicate, predicate(value) {
                forward(event)
            }
        case .completed, .error:
            forward(event)
            dispose()
        }
    }

    func forward(_ event: Event) {
        if let observer = observer {
            print("FilterSink forwarding \(event)")
            observer.on(event)
        }
    }

    func dispose() {
        if source != nil {
            source?.dispose()
            source = nil
            observer = nil
            predicate = nil
            print("FilterSink disposed")
        }
    }

}
