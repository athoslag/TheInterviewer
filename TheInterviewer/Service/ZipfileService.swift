//
//  ZipfileService.swift
//  TheInterviewer
//
//  Created by Athos Lagemann on 01/10/19.
//  Copyright © 2019 Athos Lagemann. All rights reserved.
//

import Foundation
import Zip

final class ZipfileService {
    
    private init() { /* empty */ }
    
    static func zipFilesAt(path: URL, filename: String) -> URL? {
        do {
            return try Zip.quickZipFiles([path], fileName: filename)
        } catch {
            return nil
        }
    }
}
