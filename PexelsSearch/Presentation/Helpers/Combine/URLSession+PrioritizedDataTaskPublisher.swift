//
//  URLSession+PrioritizedDataTaskPublisher.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/15/25.
//


import Combine
import Foundation

extension URLSession {
    func prioritizedDataTaskPublisher(
        url: URL,
        taskPriority: Float = URLSessionDataTask.defaultPriority
    ) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        return PrioritizedDataTaskPublisher(
            url: url,
            session: .shared,
            taskPriority: taskPriority
        )
        .eraseToAnyPublisher()
    }
}

struct PrioritizedDataTaskPublisher : Publisher, Sendable {
    typealias Output = (data: Data, response: URLResponse)
    typealias Failure = Error
    
    let request: URLRequest
    let session: URLSession
    let taskPriority: Float
    
    init(
        request: URLRequest,
        session: URLSession,
        taskPriority: Float = URLSessionDataTask.defaultPriority
    ) {
        self.request = request
        self.session = session
        self.taskPriority = taskPriority
    }
    
    init(
        url: URL,
        session: URLSession,
        taskPriority: Float = URLSessionDataTask.defaultPriority
    ) {
        self.request = URLRequest(url: url)
        self.session = session
        self.taskPriority = taskPriority
    }
    
    func receive<S>(
        subscriber: S
    ) where S : Subscriber, S.Failure == Error, S.Input == (data: Data, response: URLResponse) {
        let subscription = URLSessionSubscription(
            subscriber: subscriber,
            urlSession: session,
            urlRequest: request,
            taskPriority: taskPriority
        )
        return subscriber.receive(subscription: subscription)
    }
}

final class URLSessionSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == (data: Data, response: URLResponse), SubscriberType.Failure == Error {
    private var subscriber: SubscriberType?
    private let urlSession: URLSession
    private let urlRequest: URLRequest
    private let taskPriority: Float
    
    init(
        subscriber: SubscriberType?,
        urlSession: URLSession,
        urlRequest: URLRequest,
        taskPriority: Float = URLSessionDataTask.defaultPriority
    ) {
        self.subscriber = subscriber
        self.urlSession = urlSession
        self.urlRequest = urlRequest
        self.taskPriority = taskPriority
    }
    
    func request(_ demand: Subscribers.Demand) {
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            if let error {
                self?.subscriber?.receive(completion: .failure(error))
            }
            if let data, let response {
                _ = self?.subscriber?.receive((data, response))
            }
        }
        task.priority = taskPriority
        task.resume()
    }
    
    func cancel() {
        subscriber = nil
    }
}
