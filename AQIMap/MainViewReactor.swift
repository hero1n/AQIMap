//
//  MainReactor.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/10.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import ReactorKit

class MainViewReactor: Reactor {
    enum Action {
//        case showMap
//        case set
//        case back
    }
    
    enum Mutation {
//        case setLoading(Bool)
    }
    
    struct State {
//        var viewStatus: MainViewController.ViewStatus = .main
//        var isLoading: Bool = false
    }
    
    let initialState = State()
    
    func mutate(action: MainViewReactor.Action) -> Observable<MainViewReactor.Mutation> {
//        switch action {
//        }
//        return .just(Mutation.setLoading(true))
        return .empty()
    }
    
    func reduce(state: MainViewReactor.State, mutation: MainViewReactor.Mutation) -> MainViewReactor.State {
        var newState = state
        
        switch mutation {
//        case .setLoading(let isLoading):
//            newState.isLoading = isLoading
        }
        
        return newState
    }
}
