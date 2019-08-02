//
//  Log.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import Foundation

func DPrint(_ text: @autoclosure () -> String) {
    let s = text()
    #if DEBUG
    fatalError(s)
    #else
    print(s)
    #endif
}
