//
//  Formatter.swift
//  aqualogicpal
//
//  Created by Bryce Callender on 10/11/23.
//

import SwiftUI

struct Formatter {
    public static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    public static let timeIntervalFormatter: DateComponentsFormatter = {
        let dcf = DateComponentsFormatter()
        return dcf
    }()
}
