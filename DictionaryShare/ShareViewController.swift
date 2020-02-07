//
//  ShareViewController.swift
//  DictionaryShare
//
//  Created by Thao Le on 5/18/19.
//  Copyright © 2019 Thao Le. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        redirectToHostApp(withContent: contentText)
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Selected Deck"
            deck.value = "Deck Title"
            deck.tapHandler = {
                // on tap
            }
            return [deck]
        }
        return nil
        //return []
    }
    
    private func redirectToHostApp(withContent string: String) {
        let url: URL? = URL(string: "TLDictionary://selected=\(string)")
        var responder: UIResponder? = self as UIResponder?
        let selectorOpenURL: Selector = sel_registerName("openURL:")
        
        while responder != nil {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder?.next
        }
    }
    
    
    
}
