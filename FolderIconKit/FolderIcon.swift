//
//  FolderIcon.swift
//  FolderIconKit
//
//  Created by Pedro José Pereira Vieito on 03/07/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphicsKit
import Cocoa

public struct FolderIcon {
    private static let templateSize = CGSize(width: 1024, height: 1024)
    
    private let maskImageURL: URL?
    
    private let whiteMaskOffset = 1
    private let whiteMaskOpacity = 100
    
    public var maskSizeScale: CGFloat = 0.45
    public var maskOffset: CGPoint = CGPoint(x: 0, y: 0.3)
    public var maskOpacity: CGFloat = 0.3
    
    public init(maskImageURL: URL?) {
        self.maskImageURL = maskImageURL
    }
}

extension FolderIcon {
    internal static func renderTemplateImageURL() throws -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .resolvingSymlinksInPath()
        let templateImage = NSWorkspace.shared.icon(forFile: temporaryDirectory.path)
        var templateImageRect = CGRect(origin: .zero, size: FolderIcon.templateSize)
        let templateCGImage = templateImage.cgImage(
            forProposedRect: &templateImageRect, context: nil, hints: nil)!
        
        let templateImageURL = FileManager.default.temporaryRandomPNGImageURL()
        try templateCGImage.write(to: templateImageURL, format: .png)
        return templateImageURL
    }
    
    public func render() throws -> URL {
        let templateImageURL = try FolderIcon.renderTemplateImageURL()
        let temporaryOutputURL: URL
        
        if let inputMaskImageURL = maskImageURL {
            let resizedMaskImageURL = FileManager.default.temporaryRandomPNGImageURL()
            
            let maskSize = FolderIcon.templateSize.scaled(by: maskSizeScale)
            try ImageMagick.convert.runProcess(
                inputImageURL: inputMaskImageURL,
                outputImageURL: resizedMaskImageURL,
                options: [
                    "-trim", "-resize",
                    "\(Int(maskSize.width))x\(Int(maskSize.height))",
                    "-bordercolor", "none",
                    "-border", "10",
                    "-alpha", "extract",
                    "-alpha", "off",
                    "-alpha", "copy",
                    "-channel", "RGB", "-negate"
                ]
            )
            
            temporaryOutputURL = FileManager.default.temporaryRandomPNGImageURL()
            
            let engravingOptions = [
                "(", "(", resizedMaskImageURL.path, "-colorize", "3,23,40", ")", "(", "(", "(", resizedMaskImageURL.path, "(", resizedMaskImageURL.path, "-channel", "rgb", "-negate", "+channel", "-shadow", "100x1+10+0", "-geometry", "-2-2", ")", "-compose", "dst-out", "-composite", "+repage", ")", "(", resizedMaskImageURL.path, "(", resizedMaskImageURL.path, "-channel", "rgb", "-negate", "+channel", "-geometry", "+0-1", ")", "-compose", "dst-out", "-composite", "+repage", "-channel", "rgb", "-negate", "+channel", "-geometry", "+0+\(whiteMaskOffset)", ")", "-compose", "dissolve", "-define", "compose:args=\(whiteMaskOpacity)x50", "-composite", "+repage", ")", "(", resizedMaskImageURL.path, "(", resizedMaskImageURL.path, "-channel", "rgb", "-negate", "+channel", "-geometry", "+0+1", ")", "-compose", "dst-out", "-composite", "+repage", ")", "-compose", "dissolve", "-define", "compose:args=50x80", "-composite", ")", "-compose", "dissolve", "-define", "compose:args=60x\(self.maskOpacity.byteScaled)", "-composite", "+repage", "-gravity", "Center", "-geometry", "+\(self.maskOffset.x.byteScaled)+\(self.maskOffset.y.byteScaled)", "+repage", ")", "-compose", "over", "-composite"
            ]
            
            try ImageMagick.convert.runProcess(
                inputImageURL: templateImageURL,
                outputImageURL: temporaryOutputURL,
                options: engravingOptions
            )
        }
        else {
            temporaryOutputURL = templateImageURL
        }
        
        return temporaryOutputURL
    }
}

extension FileManager {
    fileprivate func temporaryRandomPNGImageURL() -> URL {
        return self.temporaryRandomFileURL(
            pathExtension: CGImage.OutputFormat.png.pathExtension)
    }
}

extension CGFloat {
    fileprivate var byteScaled: Int8 {
        return Int8(self * CGFloat(Int8.max))
    }
}
