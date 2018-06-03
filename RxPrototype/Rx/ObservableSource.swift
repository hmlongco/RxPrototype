//
//  ObservableSource.swift
//  RxPrototype
//
//  Created by Michael Long on 6/3/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

protocol ObservableSource: Disposable {
    func run()
}
