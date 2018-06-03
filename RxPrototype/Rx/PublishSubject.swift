//
//  PublishSubject.swift
//  RxPrototype
//
//  Created by Michael Long on 6/3/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import Foundation

class PublishSubject: Observable, ObserverType {
    private static var count: Int = 0

    private var subscribers = [Int:PublishSubjectSubscription]()
    private var mutex = pthread_mutex_t()

    func subscribe(_ observer: Observer) -> ObservableSource {
        print("PublishSubject subscribing")
        pthread_mutex_lock(&mutex); defer { pthread_mutex_unlock(&mutex) }
        let id = PublishSubject.count + 1
        PublishSubject.count = id
        let subscription = PublishSubjectSubscription(self, observer, id)
        subscribers[id] = subscription
        return subscription
    }

    func on(_ event: Event) {
        print("PublishSubject forwarding event \(event)")
        for (_, subscriber) in subscribers {
            subscriber.on(event)
        }
    }

    func remove(_ id: Int) {
        print("PublishSubject removing \(id)")
        pthread_mutex_lock(&mutex); defer { pthread_mutex_unlock(&mutex) }
        subscribers.removeValue(forKey: id)
    }

}

class PublishSubjectSubscription: ObservableSource, Observer {

    let id: Int

    weak var subject: PublishSubject?
    weak var observer: Observer?

    init(_ subject: PublishSubject, _ observer: Observer, _ id: Int) {
        print("PublishSubjectSubscription creating")
        self.subject = subject
        self.observer = observer
        self.id = id
    }

    func on(_ event: Event) {
        if let observer = observer {
            print("PublishSubjectSubscription forwarding event \(event)")
            observer.on(event)
        } else {
            dispose()
        }
    }

    func run() {}

    func dispose() {
        subject?.remove(id)
        subject = nil
        observer = nil
        print("PublishSubjectSubscription disposed")
    }

}
