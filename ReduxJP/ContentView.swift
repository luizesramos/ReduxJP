//
//  ContentView.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private struct Props {
        var users: [User] = .init()
    }
    
    private func map(userState: UsersState) -> Props {
        Props(users: userState.users)
    }
    
    private var props: Props {
        map(userState: store.state.usersState)
    }
    
    var body: some View {
        NavigationStack {
            List(props.users, id: \.id) { item in
                NavigationLink(value: item) {
                    Text(item.name)
                }
            }
            .refreshable {
                debugPrint("Refresh content")
            }
            //.toolbar { toolbar }
        }
    }
    
//    @ToolbarContentBuilder
//    var toolbar: some ToolbarContent {
//        ToolbarItem {
//            Button(action: {}) {
//                Image(systemName: "arrow.clockwise.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let usersState = UsersState(selectedUserID: nil, users: [
            Preview.user(1,"Arthur Mock"),
            Preview.user(2,"Beth Mock"),
            Preview.user(3,"Curtix Mock"),
            Preview.user(4,"Daniel Mock"),
            Preview.user(5,"Edward Mock"),
            Preview.user(6,"Ferdnand Mock")
        ])
        let store = Store<AppState>(state: .init(usersState: usersState),
                                    reducer: appReducer,
                                    midlewares: [])
        ContentView()
            .environmentObject(store)
    }
}
