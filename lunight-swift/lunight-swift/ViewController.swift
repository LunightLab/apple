//
//  ViewController.swift
//  lunight-swift
//
//  Created by lunight on 1/13/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // ISO-8859-1 > EUC-KR 인코딩
    func masterIso8859_1toEucKrEncoding() {
        
        // euckr 인코딩 셋
        let rawEucKrEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.dosKorean.rawValue))
        let EUCKR_ENC = String.Encoding(rawValue: rawEucKrEncoding)
        
    }
    
    
    /// EUC-KR에서 지원되지 않는 문자 및 특수문자 공백 제거
    /// - Parameter text: text
    /// - Returns: result
    func removeUnsupportedCharacters(from text: String) -> String {
        // 허용할 문자셋 (한글, 영문, 숫자, 일반적인 문장 부호)
        let allowedCharset = CharacterSet(charactersIn: "가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9 .,!?()\"'").inverted
        
        // EUC-KR에서 지원되지 않는 특수 공백 제거
        let specialWhitespace = ["\u{00A0}", "\u{200B}", "\u{200C}", "\u{200D}", "\u{202F}", "\u{205F}", "\u{3000}"]
        
        var cleanedText = text.components(separatedBy: allowedCharset).joined()
        
        for space in specialWhitespace {
            cleanedText = cleanedText.replacingOccurrences(of: space, with: " ")
        }
        
        return cleanedText
    }
    
    // 변환 디버깅 함수
    func debugEncodingConversion(data: Data) {
        let kEucKrEncodingValue: CFStringEncoding = 0x0942 // kCFStringEncodingEUC_KR 값
        let rawEucKrEncoding = CFStringConvertEncodingToNSStringEncoding(kEucKrEncodingValue)
        let EUCKR_ENC_N = String.Encoding(rawValue: rawEucKrEncoding)
        // Step 1: ISO-8859-1로 변환 시도
        if let isoString = String(data: data, encoding: .isoLatin1) {
            print("✅ ISO-8859-1 변환 성공: \(isoString)")
            
            // Step 2: 특수문자 및 공백 처리
            let cleanedString = removeUnsupportedCharacters(from: isoString)
            print("🔹 특수문자 제거 후: \(cleanedString)")
            
            // Step 3: UTF-8 변환 시도
            if let utf8Data = cleanedString.data(using: .utf8),
               let utf8String = String(data: utf8Data, encoding: .utf8) {
                print("✅ UTF-8 변환 성공: \(utf8String)")
                
                // Step 4: UTF-8 → EUC-KR 변환 시도
                let kEucKrEncodingValue: CFStringEncoding = 0x0942 // kCFStringEncodingEUC_KR 값
                let rawEucKrEncoding = CFStringConvertEncodingToNSStringEncoding(kEucKrEncodingValue)
                let EUCKR_ENC = String.Encoding(rawValue: rawEucKrEncoding)

                if let eucKrData = utf8String.data(using: EUCKR_ENC),
                   let eucKrString = String(data: eucKrData, encoding: EUCKR_ENC) {
                    print("✅ EUC-KR 변환 성공: \(eucKrString)")
                } else {
                    print("🚫 EUC-KR 변환 실패! 문자열 내용: \(utf8String)")
                }
            } else {
                print("🚫 UTF-8 변환 실패! 문자열 내용: \(cleanedString)")
            }
        } else {
            print("🚫 ISO-8859-1 변환 실패! 원본 데이터 바이트: \(data)")
        }
    }
    
//    // temp function
//    func setItemGTSStockInfo(br: BufferedReader)
//    {
//        var strCode: String = ""
//        var strName: String = ""
//        
//        if let dtData: Data = br.dtContents {
//            //            let str = dtData.withUnsafeBytes { String(decoding: $0, as: UTF8.self) }
//            //            TimeLog("GtsStock 파싱 로드")
//            let str = String(data: dtData, encoding: EUCKR_ENC)
//            let lines = str?.utf8.split(separator: UInt8(ascii: "\n")).map(String.init)
//            
//            // 1. ISO-8859-1에서 UTF-8로 변환
//            //            if let isoString = String(data: dtData, encoding: .isoLatin1) {
//            //                // 2. UTF-8에서 EUC-KR로 변환
//            //                if let eucKrData = isoString.data(using: EUCKR_ENC),
//            //                   let eucKrString = String(data: eucKrData, encoding: EUCKR_ENC) {
//            //                    let lines = eucKrString.utf8.split(separator: UInt8(ascii: "\n")).map(String.init)
//            //                    print("⭐️lines : \(lines)")
//            //                } else {
//            //                    print("🚫EUC-KR 변환 실패")
//            //                }
//            //            } else {
//            //                print("🚫ISO-8859-1 디코딩 실패")
//            //            }
//            
//            if let dtData: Data = br.dtContents {
//                debugEncodingConversion(data: dtData)  // 변환 디버깅 호출
//            }
//            
//            //            // ISO-8859-1 → UTF-8 → EUC-KR 변환
//            //            if let isoString = String(data: dtData, encoding: .isoLatin1) {
//            //                // 특수문자 및 공백 처리
//            //                let cleanedString = removeUnsupportedCharacters(from: isoString)
//            //
//            //                // UTF-8로 변환
//            //                if let utf8Data = cleanedString.data(using: .utf8),
//            //                   let utf8String = String(data: utf8Data, encoding: .utf8) {
//            //
//            //                    // UTF-8 → EUC-KR 변환
//            //                    let kEucKrEncodingValue: CFStringEncoding = 0x0942 // kCFStringEncodingEUC_KR 값
//            //                    let rawEucKrEncoding = CFStringConvertEncodingToNSStringEncoding(kEucKrEncodingValue)
//            //                    let EUCKR_ENC = String.Encoding(rawValue: rawEucKrEncoding)
//            //
//            //                    if let eucKrData = utf8String.data(using: EUCKR_ENC_N),
//            //                       let eucKrString = String(data: eucKrData, encoding: EUCKR_ENC_N) {
//            //                        print("✅ 변환 성공: \(eucKrString)")
//            //                    } else {
//            //                        print("🚫 EUC-KR 변환 실패")
//            //                    }
//            //                } else {
//            //                    print("🚫 UTF-8 변환 실패")
//            //                }
//            //            } else {
//            //                print("🚫 ISO-8859-1 디코딩 실패")
//            //            }
//            
//            
//            //            if let isoString = String(data: dtData, encoding: .isoLatin1) {
//            //                for char in isoString {
//            //                    if char.asciiValue == nil || char.asciiValue! > 127 {  // ASCII가 아니면 출력
//            //                        print("깨질 가능성이 있는 문자: \(char) (U+\(String(format: "%04X", char.unicodeScalars.first!.value)))")
//            //                    }
//            //                }
//            //            }
//            //            TimeLog("GtsStock 파싱 로드 끝")
//        }
}

