//
//  TrackingVerifier.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import XCTest
import Embassy
import EnvoyAmbassador

// Based on https://envoy.engineering/embedded-web-server-for-ios-ui-testing-8ff3cef513df

class TrackingVerifier {
    private let port = 8080
    private var eventLoop: EventLoop!
    private var server: HTTPServer!
    private var eventLoopThreadCondition: NSCondition!
    private var eventLoopThread: Thread!
    private var events: [TrackingEvent] = []
    private let jsonDecoder = JSONDecoder()
    
    private unowned var testCase: XCTestCase!
    
    public init(with testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    public func start() {
        
        eventLoop = try! SelectorEventLoop(selector: try! KqueueSelector())
        server = DefaultHTTPServer(eventLoop: eventLoop, port: port) { [weak self] environ, startResponse, _ in
            let input = environ["swsgi.input"] as! SWSGIInput
            input { data in
                guard let self = self,
                    let event = try? self.jsonDecoder.decode(TrackingEvent.self, from: data) else { return }
                    self.events.append(event)
            }
            
            startResponse("200 OK", [])
        }
        // Start HTTP server to listen on the port
        try! server.start()
        
        eventLoopThreadCondition = NSCondition()
        eventLoopThread = Thread(target: self, selector: #selector(runEventLoop), object: nil)
        eventLoopThread.start()
        
    }
    
    public func stop() {
        server.stopAndWait()
        eventLoopThreadCondition.lock()
        eventLoop.stop()
        while eventLoop.running {
            if !eventLoopThreadCondition.wait(until: Date().addingTimeInterval(10)) {
                fatalError("Join eventLoopThread timeout")
            }
        }
        
        events = []
    }
    
    @objc private func runEventLoop() {
      eventLoop.runForever()
      eventLoopThreadCondition.lock()
      eventLoopThreadCondition.signal()
      eventLoopThreadCondition.unlock()
    }

    public func wait(for event: TrackingEvent) {
        let predicate = NSPredicate { [weak self] _, _ in
            self?.events.contains(event) == true
        }
        let expectation = testCase.expectation(for: predicate, evaluatedWith: self, handler: nil)
        testCase.wait(for: [expectation], timeout: 10.0)
    }
}
