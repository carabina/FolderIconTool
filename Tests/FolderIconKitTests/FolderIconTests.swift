//
//  FolderIconTests.swift
//  FolderIconKitTests
//
//  Created by Pedro José Pereira Vieito on 24/11/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit
import Cocoa
import XCTest
@testable import FolderIconKit

class FolderIconTests: XCTestCase {
    static let testBundle = Bundle.currentModuleBundle()
    
    func testFolderIconTemplateImage() throws {
        let folderTemplateImageURL = try FolderIcon.renderTemplateImageURL()
        let folderTemplateImage = NSImage(contentsOf: folderTemplateImageURL)
        XCTAssertNotNil(folderTemplateImage)
    }
    
    func testFolderIcon() throws {
        let maskImageURL = FolderIconTests.testBundle.url(forResource: "GitHub", withExtension: "png")!
        let folderIcon = FolderIcon(maskImageURL: maskImageURL)

        if Process.getExecutableURL(name: "convert") == nil {
            XCTAssertThrowsError(try folderIcon.render())
        }
        else {
            let folderIconURL = try folderIcon.render()
            let folderIconImage = NSImage(contentsOf: folderIconURL)
            XCTAssertNotNil(folderIconImage)
        }
    }
}
