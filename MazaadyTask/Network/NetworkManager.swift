//
//  RequestManager.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation
import Moya

class NetworkManager {
    
    class func beginRequest<T: Codable, ProviderType: TargetType>(withTarget target: ProviderType,
                                                                   responseModel model: T.Type,
                                                                   andHandler handler: @escaping (Result<T, Error>)->()) {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        let provider = MoyaProvider<ProviderType>(plugins: [networkLogger])
        provider.request(target) { (result) in
           
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        let model = try JSONDecoder().decode(T.self, from: response.data)
                        handler(.success(model))
                    }catch let error{
                        handler(.failure(error))
                    }
                }else {
                    if let reason = TKError(rawValue: response.statusCode) {
                        handler(.failure(reason))
                    }else {
                        handler(.failure(TKError.notHandleStatusCode))
                    }
                }
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
    class func handleGeneralResponse<I>(result: (Result<BaseResponse<I>, Error>), completionHandler: @escaping (I?,String?) -> ()){
        switch result {
        case .success(let baseResponse):
            print("Response: \(baseResponse)")
            switch baseResponse.code{
            case 200:
                print("success")
                if baseResponse.data == nil {
                    completionHandler(baseResponse.msg as? I, nil)
                }else {
                    completionHandler(baseResponse.data, nil)
                }
                
            default:
                completionHandler(nil, baseResponse.msg)
            }
        case .failure(let error):
            print("Error: \(error)")
            if let errors = error as? TKError {
                completionHandler(nil, errors.getErrorMessage() ??  "unknownError")
            }else {
                completionHandler(nil, "unknownError")
            }
        }
    }
}
