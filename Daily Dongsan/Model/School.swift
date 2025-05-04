//
//  School.swift
//  geubchelin
//
//  Created by 최지한 on 1/25/25.
//

import Foundation

struct School {
    let officeCode: String
    let code: String
    let name: String
    let address: String
}

struct SchoolResponse: Decodable {
    let schoolInfo: [SchoolInfo]
}

struct SchoolInfo: Decodable {
    let row: [SchoolRow]?
}

struct SchoolRow: Decodable {
    let ATPT_OFCDC_SC_CODE: String // 시도교육청코드
    let SD_SCHUL_CODE: String // 행정표준코드
    let SCHUL_NM: String // 학교명
    let ORG_RDNMA: String // 도로명주소
}

struct Region {
    let name: String
    let tag: String
}
