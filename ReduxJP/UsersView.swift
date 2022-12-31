//
//  UsersView.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private struct Props {
        var users: [User] = .init()
        var fetchUsers: () -> Void
    }
    
    private func map(userState: UsersState) -> Props {
        Props(users: userState.users,
              fetchUsers: { store.dispatch(action: FetchUsers()) })
    }
    
    private var props: Props {
        map(userState: store.state.usersState)
    }
    
    var body: some View {
        NavigationStack {
            List(props.users, id: \.id) { item in
                NavigationLink(value: item) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                        Text(item.company.name)
                    }
                }
            }
            .navigationDestination(for: User.self) { item in
                Text(item.website)
            }
            .refreshable {
                Log.app.i("Refresh users")
                props.fetchUsers()
            }
            .navigationTitle("Users")
        }
        .onAppear {
            props.fetchUsers()
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let usersState = UsersState(users: [
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
        UsersView()
            .environmentObject(store)
    }
}
