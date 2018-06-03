//
//  Sink.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

//class Sink: Observer, Disposable {
//
//    var source: ObservableSource?
//    var observer: Observer?
//
//    init(_ observable: Observable?, _ observer: Observer) {
//        self.observer = observer
//        self.source = observable?.subscribe(self)
//    }
//
//    func on(_ event: Event) {
//        forward(event)
//    }
//
//    func forward(_ event: Event) {
//        if let observer = observer {
//            print("Forwarding \(event)")
//            observer.on(event)
//        }
//    }
//
//    deinit {
//        dispose()
//    }
//
//    func dispose() {
//        if source != nil {
//            source?.dispose()
//            source = nil
//            observer = nil
//        }
//    }
//
//}
