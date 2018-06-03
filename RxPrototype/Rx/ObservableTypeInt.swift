//
//  ObservableTypeInt.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

// Dummy class just so I have a concrete instance of a protocol
class ObservableInt: ObservableType {

    func subscribe(_ observer: Observer) -> ObservableSource {
        fatalError()
    }

}
