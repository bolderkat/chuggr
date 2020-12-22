//
//  AddFriendsViewModel.swift
//  CHUGGR
//
//  Created by Daniel Luo on 12/15/20.
//

import Foundation

class AddFriendViewModel {
    private let firestoreHelper: FirestoreHelper
    private var friendUIDs: Set<UID> {
        // Used so already added users do not appear in search
        Set(firestoreHelper.friends.map { $0.uid })
    }
    private var searchResults: [FriendCellViewModel] = []
    private(set) var isLoading = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var updateLoadingStatus: (() -> ())?
    var onFriendFetch: ((FullFriend) -> ())?
    
    init(firestoreHelper: FirestoreHelper) {
        self.firestoreHelper = firestoreHelper
    }
    
    func initSetUpAllUserListener() {
        isLoading = true
        firestoreHelper.addAllUserListener { [weak self] in
            self?.isLoading = false
        }
    }
    
    func createCellVMs(from users: [FullFriend]) -> [FriendCellViewModel] {
        var vms = [FriendCellViewModel]()
        for user in users {
            let vm = FriendCellViewModel(friend: user)
            vms.append(vm)
        }
        return vms
    }
    
    func provideCellVMs(forString searchString: String) -> [FriendCellViewModel] {
        let string = searchString.lowercased() // case-insensitive search
        let userSearchResults = firestoreHelper.allUsers.filter {
            $0.firstName.lowercased().contains(string) ||
                $0.lastName.lowercased().contains(string) ||
                $0.userName.lowercased().contains(string) ||
                "\($0.firstName) \($0.lastName)".lowercased().contains(string)
        }
        // Remove results that user has already followed
        let filteredResults = userSearchResults.filter { !friendUIDs.contains($0.uid) }
        let vms = createCellVMs(from: filteredResults)
        searchResults = vms
        return vms
    }
    
    func provideSelectedFriend(at indexPath: IndexPath) -> FullFriend {
        guard let friend = searchResults[indexPath.row].friend as? FullFriend else {
            fatalError("Found FriendSnippet instead of FullFriend when retrieving friend from AddFriendViewModel search results")
        }
        return friend
    }
    
    func getFreshData(for friend: FullFriend) {
        firestoreHelper.getFriend(withUID: friend.uid) { [weak self] friend in
            self?.onFriendFetch?(friend)
        }
    }
    
}

