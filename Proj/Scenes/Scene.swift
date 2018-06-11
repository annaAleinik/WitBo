//
//  Scene.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum Scene {
	
	case share([Any])
	
	case navigation(NavigationControllerModel)
	
	case empty
	
//	// MARK: - Authentication
	case login(LoginViewModel)
	case register(RegisterViewModel)

//	// MARK: - Profile
//	case profile(ProfileViewModel)
//	
//	// MARK: - Welcome
//	case welcome(WelcomeViewModelBase)
//	
//	//MARK: - Popup scenes
//	case monthDayPicker(MonthDayPickerViewModel)
//	
//	// MARK: - Simple lists
//
//	
//	//MARK: - Users
//	case friendsList(FriendsListViewModel)
//	case addFriends(AddFriendsViewModel)
//	
	//MARK: - TabBar
	case tabBar(WBTabBarViewModel)
//
//	//MARK: - Settings
//	
//	case settings(SettingsViewModel)
//	case privacy(PrivacyViewModel)
//	case policy(TermsOfServiceViewModel)
//	case changePassword(ChangePasswordViewModel)
//	
//	//MARK: - Search
//	case search(SearchViewModel)

}
