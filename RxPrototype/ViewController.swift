//
//  ViewController.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var disposable2: Disposable? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Creating observable chain")
        let observable = ObservableInt.just(4)
            .something()
            .something()

        print("\n\nSubscription 1")
        var disposable1: Disposable? = observable
            .subscribe(on: { e in
                print("Event: \(e)")
            })
        disposable1 = nil

        print("\n\nSubscription 2")
        disposable2 = observable
            .subscribe(on: { e in
                print("Event: \(e)")
            })


    }


}

