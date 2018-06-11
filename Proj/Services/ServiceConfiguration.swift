//
//  ServiceConfiguration.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift

/// Services Configuration
open class ServicesConfiguration {
	
	// MARK: - Public services
	
	public let authentication: AuthenticationService
//	public let profile: ProfileService
//	public let settings: SettingsService
//	public let categories: CategoriesService
//	public let moods: MoodsService
//	public let goals: GoalsService
//	public let tasks: TasksService
//	public let habits: HabitsService
//	public let steps: StepsService
//	public let booxs: BooxService
//	public let choices: ChoicesService
//	public let users: UsersService
	public let credentials: CredentialsService
//	public let location: LocationService
//	public let gidget: GidgetService
//	public let groups: GroupsService
//	public let friends: FriendsService
//	public let meetups: MeetupService
//	public let search: SearchService
//	public let friendRequests: FriendRequestsService
//	public let contacts: ContactsService
//	public let notification: NotificationService
//	public let google:GoogleService
//	public let subscription: SubscriptionService
//	public let iap: IAPService
	
	
	/// Becomes true if user was successfully logged in and services perform their activation.
//	public let areAllUserRelatedServicesReady: Observable<Bool>
	
	// MARK: - Private services
//
	let networking: NetworkingService
	let keyValue: KeyValueStorage
//	let localStorage: LocalStorageService
//
	// MARK: - Init
	
	public init(sharedFolder: String? = "") throws {
		self.keyValue = UserDefaultsStorage()
		self.credentials = CredentialsServiceV1(backingStorage: keyValue)
		self.networking = NetworkingServiceV1(credentials: credentials)
		self.authentication = AuthenticationServiceV1(networking: networking, credentials: credentials)
////		self.profile = ProfileServiceV1(credentials: credentials, networking: networking)
////		self.settings = SettingsServiceV1(credentials: credentials, networking: networking)
////		self.users = UsersServiceV1(networking: networking, profile: profile)
//		
////		let services: [AnyService] = [ keyValue, credentials, networking, authentication, profile, settings, users]
//		
////		self.areAllUserRelatedServicesReady = Observable
////			.combineLatest(services.map { $0.isReady })
////			.map { $0.reduce(true, { $0 && $1 }) }
////			.distinctUntilChanged()
////			.share(replay: 1, scope: .forever)
//		
	}
}
