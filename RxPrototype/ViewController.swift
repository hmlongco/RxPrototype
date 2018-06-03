//
//  ViewController.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var disposable1: Disposable? = nil
    var disposable4: Disposable? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Creating observable chain")
        let observable = ObservableInt.just(4)
            .filter { $0 > 0 }
            .filter { $0 < 3 }
            .something()

        print("\n\nSubscription 1")
        disposable1 = observable
            .subscribe(on: { e in
                print("Event: \(e)")
            })

        print("\n\nSubscription 2")
        var disposable2: Disposable? = observable
            .subscribe(on: { e in
                print("Event: \(e)")
            })
        disposable2 = nil

        print("\n\nSubscription 3")
        _ = observable
            .subscribe(on: { e in
                print("Event: \(e)")
            })

        print("\n\nSubscription 4")
        self.disposable4 = ObservableInt.create({ (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                observer.onNext(15)
                observer.onCompleted()
            })
            return NopDisposable()
            })
            .filter { $0 > 0 }
            .subscribe(on: { e in
                print("Event: \(e)")
            })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            print("\n\nSubscription 5")
            var disposable5: Disposable? = ObservableInt.create({ (observer) -> Disposable in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    observer.onNext(19)
                    observer.onCompleted()
                })
                return NopDisposable()
                })
                .filter { $0 > 0 }
                .subscribe(on: { e in
                    print("Event: \(e)")
                })
            disposable5?.dispose() // Early dispose before internal event fires
        })
    }

}

