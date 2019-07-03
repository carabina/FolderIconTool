//
//  main.swift
//  DirectoryIconTool
//
//  Created by Pedro José Pereira Vieito on 03/07/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Cocoa
import Foundation
import LoggerKit
import CommandLineKit
import CoreGraphicsKit
import FolderIconKit

let inputOption = StringOption(shortFlag: "i", longFlag: "input", required: true, helpMessage: "Input image.")
let maskOpacityOption = DoubleOption(shortFlag: "p", longFlag: "mask-opacity", helpMessage: "Mask opacity.")
let maskSizeScaleOption = DoubleOption(shortFlag: "z", longFlag: "mask-size-scale", helpMessage: "Mask size scale.")
let outputOption = StringOption(shortFlag: "o", longFlag: "output", helpMessage: "Output path.")
let targetOption = StringOption(shortFlag: "t", longFlag: "target", helpMessage: "Target directory.")
let showOption = BoolOption(shortFlag: "x", longFlag: "show", helpMessage: "Show generated icon.")
let verboseOption = BoolOption(shortFlag: "v", longFlag: "verbose", helpMessage: "Verbose mode.")
let helpOption = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

let cli = CommandLineKit.CommandLine()
cli.addOptions(inputOption, maskOpacityOption, maskSizeScaleOption, outputOption, targetOption, showOption, verboseOption, helpOption)

do {
    try cli.parse(strict: true)
}
catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if helpOption.value {
    cli.printUsage()
    exit(0)
}

Logger.logMode = .commandLine
Logger.logLevel = verboseOption.value ? .debug : .info

var folderIcon = FolderIcon(maskImageURL: inputOption.value?.pathURL)

if let maskOpacity = maskOpacityOption.value {
    folderIcon.maskOpacity = CGFloat(maskOpacity)
}

if let maskSizeScale = maskSizeScaleOption.value {
    folderIcon.maskSizeScale = CGFloat(maskSizeScale)
}

do {
    let folderIconURL = try folderIcon.render()

    if let outputURL = outputOption.value?.pathURL {
        try FileManager.default.copyItem(at: folderIconURL, to: outputURL)
    }
    
    if let targetDirectoryURL = targetOption.value?.pathURL {
        let outputImage = NSImage(contentsOf: folderIconURL)
        NSWorkspace.shared.setIcon(outputImage, forFile: targetDirectoryURL.path, options: [])
    }
    
    if showOption.value {
        try folderIconURL.open()
    }
}
catch {
    Logger.log(fatalError: error)
}
