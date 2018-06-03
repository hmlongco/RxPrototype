//
//  Something.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

typealias MapTransform = (_ value: Int) -> Int

extension ObservableType {

    func map(_ transform: @escaping MapTransform) -> Observable {
        print("Map observing")
        return MapProvider(self as? Observable, transform)
    }

}

fileprivate class MapProvider: Observable {

    var transform: MapTransform
    var observable: Observable?

    init(_ observable: Observable?, _ transform: @escaping MapTransform) {
        print("Map created")
        self.transform = transform
        self.observable = observable
    }

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("Map subscribing")
        return MapSink(observable, observer, transform)
    }

}

fileprivate class MapSink: ObservableSink {

    var transform: MapTransform?

    init(_ observable: Observable?, _ observer: Observer, _ transform: @escaping MapTransform) {
        print("MapSink created")
        self.transform = transform
        super.init(observable, observer)
    }

    deinit {
        print("MapSink deinit")
    }

    override func on(_ event: Event) {
        print("MapSink on event \(event)")
        switch event {
        case .next(let value):
            if let transform = transform {
                let newEvent = Event.next(transform(value))
                print("MapSink forwarding event \(newEvent)")
                forward(newEvent)
            }
        case .completed, .error:
            print("MapSink forwarding event \(event)")
            forward(event)
            dispose()
        }
    }

    override func dispose() {
        super.dispose()
        transform = nil
        print("MapSink disposed")
    }

}
