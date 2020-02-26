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
    self.init(documentTypes: ["public.item"], in: .open)
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
  
  func dataToBase64String(data: Data?) -> String? {
    if let data = data,
      let image = UIImage(data: data),
      let pngData = image.pngData() {
      return pngData.base64EncodedString()
    }
    
    return nil
  }
  
  func loadData(fromURL url: URL?) {
    if let _ = url?.startAccessingSecurityScopedResource(),
      let url = url,
      let data = try? Data(contentsOf: url) {
      result?(dataToBase64String(data: data))
      url.stopAccessingSecurityScopedResource()
      return
    }
    
    url?.stopAccessingSecurityScopedResource()
    result?(nil)
  }
}


extension DocumentPickerViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    loadData(fromURL: url)
    controller.dismiss(animated: false, completion: nil)
  }
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    loadData(fromURL: urls[0])
    controller.dismiss(animated: false, completion: nil)
  }
}

