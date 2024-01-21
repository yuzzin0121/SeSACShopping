//
//  ProfileImage.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import Foundation
import UIKit

enum ProfileImage: Int {
    case profile1
    case profile2
    case profile3
    case profile4
    case profile5
    case profile6
    case profile7
    case profile8
    case profile9
    case profile10
    case profile11
    case profile12
    case profile13
    case profile14

    static let profileList: [Profile] = [
        Profile(profileImage: ImageStyle.profile1, isSelected: false),
        Profile(profileImage: ImageStyle.profile2, isSelected: false),
        Profile(profileImage: ImageStyle.profile3, isSelected: false),
        Profile(profileImage: ImageStyle.profile4, isSelected: false),
        Profile(profileImage: ImageStyle.profile5, isSelected: false),
        Profile(profileImage: ImageStyle.profile6, isSelected: false),
        Profile(profileImage: ImageStyle.profile7, isSelected: false),
        Profile(profileImage: ImageStyle.profile8, isSelected: false),
        Profile(profileImage: ImageStyle.profile9, isSelected: false),
        Profile(profileImage: ImageStyle.profile10, isSelected: false),
        Profile(profileImage: ImageStyle.profile11, isSelected: false),
        Profile(profileImage: ImageStyle.profile12, isSelected: false),
        Profile(profileImage: ImageStyle.profile13, isSelected: false),
        Profile(profileImage: ImageStyle.profile14, isSelected: false)
    ]
}

struct Profile {
    let profileImage: UIImage?
    var isSelected: Bool
}
