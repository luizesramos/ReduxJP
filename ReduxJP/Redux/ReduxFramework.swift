//
//  ReduxFramework.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

protocol ReduxState {}
protocol ReduxAction {}

typealias Reducer<State: ReduxState> = (State, ReduxAction) -> State

typealias Middleware<State: ReduxState> = (State, ReduxAction, @escaping (ReduxAction) -> Void) -> Void


final class Store<State: ReduxState> {
    private var internalState: State {
        didSet { state = internalState }
    }
    private let reducer: Reducer<State>
    private let midlewares: [Middleware<State>]
    
    // public copy of the internal state (prevents changes to internal state)
    @Published var state: State

    init(state: State, reducer: @escaping Reducer<State>, midlewares: [Middleware<State>]) {
        self.internalState = state
        self.reducer = reducer
        self.midlewares = midlewares
        self.state = state
    }
    
    func dispatch(action: ReduxAction) -> ReduxState {
        Task { @MainActor in
            internalState = reducer(state, action)
        }
        
        midlewares.forEach { m in
            m(state, action, dispatch)
        }
    }
}
