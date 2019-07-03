//
//  FolderIcon.swift
//  FolderIconKit
//
//  Created by Pedro José Pereira Vieito on 03/07/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit

enum ImageMagick: String {
    case convert
    
    func runProcess(inputImageURL: URL, outputImageURL: URL, options: [String]? = nil) throws {
        let options = options ?? []
        let arguments = [inputImageURL.path] + options + [outputImageURL.path]
        
        try Process(executableName: self.rawValue, arguments: arguments)
            .runAndWaitUntilExit()
    }
}
