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

protocol Observer: class {
    func on(_ event: Event)
}

protocol ObservableSource: Disposable {
    func run()
}

protocol ObservableType {
    func subscribe(_ observer: Observer) -> ObservableSource
}

protocol Observable: ObservableType {

}
