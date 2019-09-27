//
//  Log.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//

import Foundation

#if DEBUG
private let logsDisabled = false
#else
private let logsDisabled = true
#endif

func log(_ format: String, _ args: CVarArg..., file: String = #file, function: String = #function, line: Int = #line) {

    if logsDisabled {
        return
    }

    print ("(\((file as NSString).lastPathComponent):\(line)) \(function) [\(pthread_main_np() > 0 ? "MAIN" : "BG"):\(String(format: "%x", pthread_mach_thread_np(pthread_self())))] \(String(format: format, args))")
}

func echo(_ text: String) {

    if logsDisabled {
        return
    }

    print (text)
}
