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
    
    private let systemName = UIDevice.current.systemName
    private let sytemVersion = UIDevice.current.systemVersion
    private var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let modelIdentifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            let modelIdentifier = identifier + String(UnicodeScalar(UInt8(value)))
            return modelIdentifier
        }
        return ModelName(for: modelIdentifier)
    }
    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    
    func sendEmail() {
        let recipients = "geubchelin@icloud.com"
        let subject = "급슐랭 피드백"
        let messageBody = """
        
        
        
        
        
                
        모델명: \(modelName)
        \(systemName) 버전: \(sytemVersion)
        급슐랭 버전: \(appVersion)
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
    
    func ModelName(for identifier: String) -> String {
        switch identifier {
// MARK: - iPhone
        case "iPhone11,2":                                      return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                        return "iPhone XS Max"
        case "iPhone11,8":                                      return "iPhone XR"
        case "iPhone12,1":                                      return "iPhone 11"
        case "iPhone12,3":                                      return "iPhone 11 Pro"
        case "iPhone12,5":                                      return "iPhone 11 Pro Max"
        case "iPhone13,1":                                      return "iPhone 12 mini"
        case "iPhone13,2":                                      return "iPhone 12"
        case "iPhone13,3":                                      return "iPhone 12 Pro"
        case "iPhone13,4":                                      return "iPhone 12 Pro Max"
        case "iPhone14,4":                                      return "iPhone 13 mini"
        case "iPhone14,5":                                      return "iPhone 13"
        case "iPhone14,2":                                      return "iPhone 13 Pro"
        case "iPhone14,3":                                      return "iPhone 13 Pro Max"
        case "iPhone14,7":                                      return "iPhone 14"
        case "iPhone14,8":                                      return "iPhone 14 Plus"
        case "iPhone15,2":                                      return "iPhone 14 Pro"
        case "iPhone15,3":                                      return "iPhone 14 Pro Max"
        case "iPhone15,4":                                      return "iPhone 15"
        case "iPhone15,5":                                      return "iPhone 15 Plus"
        case "iPhone16,1":                                      return "iPhone 15 Pro"
        case "iPhone16,2":                                      return "iPhone 15 Pro Max"
        case "iPhone17,3":                                      return "iPhone 16"
        case "iPhone17,4":                                      return "iPhone 16 Plus"
        case "iPhone17,5":                                      return "iPhone 16e"
        case "iPhone17,1":                                      return "iPhone 16 Pro"
        case "iPhone17,2":                                      return "iPhone 16 Pro Max"
// MARK: - iPhone SE
        case "iPhone8,4":                                       return "iPhone SE(1세대)"
        case "iPhone12,8":                                      return "iPhone SE(2세대)"
        case "iPhone14,6":                                      return "iPhone SE(3세대)"
// MARK: - iPad
        case "iPad7,5", "iPad7,6":                              return "iPad(6세대)"
        case "iPad7,11", "iPad7,12":                            return "iPad(7세대)"
        case "iPad11,6", "iPad11,7":                            return "iPad(8세대)"
        case "iPad12,1", "iPad12,2":                            return "iPad(9세대)"
        case "iPad13,18", "iPad13,19":                          return "iPad(10세대)"
// MARK: - iPad Air
        case "iPad11,3", "iPad11,4":                            return "iPad Air(3세대)"
        case "iPad13,1", "iPad13,2":                            return "iPad Air(4세대)"
        case "iPad13,16", "iPad13,17":                          return "iPad Air(5세대)"
        case "iPad14,8", "iPad14,9":                            return "iPad Air 11(M2 모델)"
        case "iPad14,10", "iPad14,11":                          return "iPad Air 13(M2 모델)"
// MARK: - iPad mini
        case "iPad11,1", "iPad11,2":                            return "iPad mini(5세대)"
        case "iPad14,1", "iPad14,2":                            return "iPad mini(6세대)"
        case "iPad16,1", "iPad16,2":                            return "iPad mini(A17 Pro 모델)"
// MARK: - iPad Pro
        case "iPad7,3", "iPad7,4":                              return "iPad Pro 10.5"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":        return "iPad Pro 11(1세대)"
        case "iPad8,9", "iPad8,10":                             return "iPad Pro 11(2세대)"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":    return "iPad Pro 11(3세대)"
        case "iPad14,3", "iPad14,4":                            return "iPad Pro 11(4세대)"
        case "iPad16,3", "iPad16,4":                            return "iPad Pro 11(M4 모델)"
        case "iPad6,7", "iPad6,8":                              return "iPad Pro 12.9(1세대)"
        case "iPad7,1", "iPad7,2":                              return "iPad Pro 12.9(2세대)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":        return "iPad Pro 12.9(3세대)"
        case "iPad8,11", "iPad8,12":                            return "iPad Pro 12.9(4세대)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPad Pro 12.9(5세대)"
        case "iPad14,5", "iPad14,6":                            return "iPad Pro 12.9(6세대)"
        case "iPad16,5", "iPad16,6":                            return "iPad Pro 13(M4 모델)"
        default:                                                return identifier
        }
    }
}
