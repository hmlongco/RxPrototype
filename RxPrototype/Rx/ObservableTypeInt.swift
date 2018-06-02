//
//  ObservableTypeInt.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

class ObservableInt: Observable {

    func subscribe(_ observer: Observer) -> Disposable {
        return NopDisposable()
    }

}
