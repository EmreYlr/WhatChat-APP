import Foundation
struct ClientToken: Codable {
    let accessToken: String
    let expiresIn, refreshExpiresIn: Int
    let tokenType: String
    let notBeforePolicy: Int
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case scope
    }
}
