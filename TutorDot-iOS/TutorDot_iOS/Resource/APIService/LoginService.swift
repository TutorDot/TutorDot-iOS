//
//  LoginService.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/07/12.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import Alamofire

struct LoginService {
    static let shared = LoginService()
    private func makeParameter(_ email: String, _ password: String) -> Parameters {
        return ["email": email, "password": password]
        
    }
    
    // 로그인
    func login(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = Alamofire.request(APIConstants.signinURL, method: .post, parameters: makeParameter(email, password), encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result { case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.result.value else { return }
                let networkResult = self.judge(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.networkFail)
            }
        }
    }
    
    // 아이디 중복확인
    private func makeParameter2(_ email: String) -> Parameters {
        return ["email": email]
        
    }
    func idCheck(email: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = Alamofire.request(APIConstants.idCheckURL, method: .post, parameters: makeParameter2(email), encoding: JSONEncoding.default, headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result { case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.result.value else { return }
                let networkResult = self.judge2(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.networkFail)
            }
        }
    }
    
    private func judge(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isUser(by: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
        
    }
    private func isUser(by data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignInData.self, from: data)
        else {
            return .pathErr }

        guard let tokenData = decodedData.data
        else {
            return .requestErr(decodedData.message)
            
        }
//        let list : [String] = [tokenData.accessToken, tokenData.role, tokenData.userName]
//        print(list[0], "inputlist")
        //return .success(tokenData.accessToken)
        return .success(tokenData.accessToken)
        
    }
    
    private func judge2(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            print("judge success")
            return isClassData(by: data)
        case 204:
            print("judge success2")
            return isClassData(by: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isClassData(by data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignInData.self, from: data)
            else {return .pathErr}
        print(decodedData.status, "\n", decodedData.success, "\n", decodedData.message, "\n")
        
        if decodedData.success {
            return .success(decodedData.data)
        }
        else {
            return .requestErr(decodedData.message)}
    }
    
}
