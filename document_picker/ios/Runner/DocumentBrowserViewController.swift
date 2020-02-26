//
//  DocumentBrowserViewController.swift
//  Runner
//
//  Created by Oleg on 26.02.2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class DocumentBrowserViewController : UIDocumentBrowserViewController {
  var result: FlutterResult?
  
  convenience init(result: @escaping FlutterResult) {
    self.init(forOpeningFilesWithContentTypes: ["public.image"])
    self.result = result
  }
  
  override init(forOpeningFilesWithContentTypes allowedContentTypes: [String]?) {
    super.init(forOpeningFilesWithContentTypes: allowedContentTypes)
    delegate = self
    allowsDocumentCreation = false
    allowsPickingMultipleItems = true
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

extension DocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
    data(fromURLs: documentURLs)
    controller.dismiss(animated: false, completion: nil)
  }
}
