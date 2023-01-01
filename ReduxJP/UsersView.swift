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
            List(props.users, id: \.self) { item in
                NavigationLink(destination: {
                    detailsView(user: item)
                }, label: {
                    VStack(alignment: .leading) {
                        Text(item.name)
                        Text(item.company.name)
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
        }
        .refreshable {
            Log.app.i("Refresh users")
            props.fetchUsers()
        }
        .onAppear {
            props.fetchUsers()
        }
    }
    
    @ViewBuilder
    private func detailsView(user: User) -> some View {
        VStack (alignment: .leading) {
            Group {
                Text("Name: \(user.name)")
                Text("Username: \(user.username)")
                Text("Email: \(user.email)")
                Text("Phone: \(user.phone)")
                Text("Website: \(user.website)")
                Text("Address")
            }
            .padding(.vertical)
            
            Text("\(user.address.description)")

            Spacer()
        }
        .navigationTitle("Contact information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        if !suite.isEmpty {
            return "\(street) \(suite), \(city) \(zipcode)"
        } else {
            return "\(street), \(city) \(zipcode)"
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
