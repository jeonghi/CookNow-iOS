//
//  CommonDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/25/24.
//

import Foundation

enum CommonDTO {
  
  struct Response<T: Decodable>: Decodable {
    let status: Int // 상태코드
    let message: String // 메시지
    let data: T? // 데이터
    let timestamp: Date // 타임스탬프
    
    enum CodingKeys: CodingKey {
      case status
      case message
      case data
      case timestamp
    }
    
    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<Response<T>.CodingKeys> = try decoder.container(keyedBy: Response<T>.CodingKeys.self)
      self.status = try container.decode(Int.self, forKey: Response<T>.CodingKeys.status)
      self.message = try container.decode(String.self, forKey: Response<T>.CodingKeys.message)
      self.data = try container.decodeIfPresent(T.self, forKey: Response<T>.CodingKeys.data)
      let dateString = try container.decode(String.self, forKey: Response<T>.CodingKeys.timestamp)
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
      
      if let date = formatter.date(from: dateString) {
        self.timestamp = date
      } else {
        throw DecodingError.dataCorruptedError(forKey: Response<T>.CodingKeys.timestamp, in: container, debugDescription: "Date string does not match format expected by formatter.")
      }
    }
  }
}
