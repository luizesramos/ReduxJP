//
//  ReduxFramework.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

protocol ReduxState {}
protocol ReduxAction {}

/// Reducer performs a pure function on state to produce an updated version of that state
/// - Parameters:
///   - state: the state before the pure operation
///   - action: describes a pure function to be applied on the state
/// - Returns: an updated version of the state after the action has been applied
typealias Reducer<State: ReduxState> = (State, ReduxAction) -> State

/// Middleware performs non-pure operation (e.g., network or DB action) and dispatches an action as a result of the operation
/// - Parameters:
///   - state: the state before the operation
///   - action: describes the non-pure operation to be performed
///   - closure: receives the action performed as the outcome of the non-pure operation
typealias Middleware<State: ReduxState> = (State, ReduxAction, @escaping (ReduxAction) -> Void) -> Void


final class Store<State: ReduxState>: ObservableObject {
    private var internalState: State {
        didSet { state = internalState }
    }
    private let reducer: Reducer<State>
    private let midlewares: [Middleware<State>]
    
    // public copy of the internal state (prevents direct changes to internal state)
    @Published var state: State

    init(state: State, reducer: @escaping Reducer<State>, midlewares: [Middleware<State>]) {
        self.internalState = state
        self.reducer = reducer
        self.midlewares = midlewares
        self.state = state
    }
    
    /// Schedules a pure or non-pure operation to update the Store's state
    /// - Parameter action: a pure or non-pure operation that will modify the Store's state
    func dispatch(action: ReduxAction) {
        // run all reducers first
        Task { @MainActor in
            internalState = reducer(state, action)
        }
        
        // run all middlewares next
        midlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
