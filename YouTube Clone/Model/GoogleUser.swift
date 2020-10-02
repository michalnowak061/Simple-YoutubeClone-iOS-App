//
//  GoogleUser.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 02/10/2020.
//

import Foundation

public var googleUser = GoogleUser()

public struct GoogleUser {
    var email: String = ""
    var name: String = ""
    var imageURL: String = ""
    var accessToken: String = ""
}
