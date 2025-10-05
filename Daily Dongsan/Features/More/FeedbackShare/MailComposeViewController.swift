//
//  Emailhelper.swift
//  geubchelin
//
//  Created by 최지한 on 2/22/25.
//

import Foundation
import MessageUI

class MailComposeViewController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = MailComposeViewController()
    
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    private var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let modelIdentifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            let modelIdentifier = identifier + String(UnicodeScalar(UInt8(value)))
            return modelIdentifier
        }
        return modelIdentifier
    }
    private let systemName = UIDevice.current.systemName
    private let sytemVersion = UIDevice.current.systemVersion
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    func sendEmail() {
        let recipients = "dailydongsan@icloud.com"
        let subject = "데일리 동산 피드백"
        let messageBody = """
        
        
        
        
        
        
        아래 내용을 지우지 마세요.
        \(modelName) \(sytemVersion) \(appVersion)
        """
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients([recipients])
        composeVC.setSubject(subject)
        composeVC.setMessageBody(messageBody, isHTML: false)
        
        MailComposeViewController.getRootViewController()?.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true)
    }
    
    static private func getRootViewController() -> UIViewController? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
    }
}
