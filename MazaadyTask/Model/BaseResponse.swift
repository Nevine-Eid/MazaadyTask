//
//  BaseResponse.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation

struct BaseResponse<I : Codable> : Codable {
    let code: Int?
    let msg : String?
    let data: I?
}
