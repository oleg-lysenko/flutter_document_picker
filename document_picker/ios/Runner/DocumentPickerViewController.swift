//
//  DocumentPickerViewController.swift
//  Runner
//
//  Created by Oleg on 26.02.2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerViewController {
  var result: FlutterResult?
  
  convenience init(result: @escaping FlutterResult) {
    self.init(documentTypes: ["public.image"], in: .open) //["public.item"]
    self.result = result
  }
  
  override init(documentTypes allowedUTIs: [String], in mode: UIDocumentPickerMode) {
    super.init(documentTypes: allowedUTIs, in: mode)
    delegate = self
    isEditing = false
    allowsMultipleSelection = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func data(fromURL url: URL?) -> String {
    _ = url?.startAccessingSecurityScopedResource()
    var dataString = ""
    
    if let url = url, let data = try? Data(contentsOf: url) {
      dataString = url.pathExtension.base64EncodedString(fromData: data)
    }
    
    url?.stopAccessingSecurityScopedResource()
    return dataString
  }
  
  func data(fromURLs urls: [URL]) {
    result?(urls.map () { data(fromURL: $0) })
  }
}

extension String {
  func base64EncodedString(fromData data: Data) -> String {
    if self.uppercased() == "HEIC" || self.uppercased() == "TIFF" {
      let image = UIImage(data: data)
      return image?.pngData()?.base64EncodedString() ?? ""
    } else {
      return data.base64EncodedString()
    }
  }
}

extension DocumentPickerViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    data(fromURLs: urls)
    controller.dismiss(animated: false, completion: nil)
  }
}

