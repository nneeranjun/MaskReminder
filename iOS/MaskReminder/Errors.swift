//
//  Errors.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/27/20.
//

import Foundation

enum SaveError: Error {
    case DuplicateName
    case SystemError
    case DuplicateLocation
}

enum DeleteError: Error {
    case NonExistant
    case SystemError
}
