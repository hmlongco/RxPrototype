//
//  Sink.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

class Sink: Observer, Disposable {

    var source: ObservableSource?

    init(_ observable: Observable?) {
        self.source = observable?.subscribe(self)
    }

    func on(_ event: Event) {
        fatalError("Abstract")
    }

    deinit {
        if source != nil {
            dispose()
        }
    }

    func dispose() {
        source?.dispose()
        source = nil
    }

}

class ObservableSink: Sink, ObservableSource {

    weak var observer: Observer?

    init(_ observable: Observable?, _ observer: Observer) {
        self.observer = observer
        super.init(observable)
    }

    func run() {
        source?.run()
    }

    func forward(_ event: Event) {
        observer?.on(event)
    }

    override func dispose() {
        observer = nil
        super.dispose()
    }

}
