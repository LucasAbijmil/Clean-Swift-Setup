//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import StoreKit
import Swinject
import SwinjectAutoregistration

extension Container {

  func setup() -> Self {
    registerNetworks()
    registerServices()
    registerWorkers()
    registerCommons()
    registerDatabase()
    return self
  }

  private func registerNetworks() {
    autoregister(NetworkClient.self, initializer: DefaultNetworkClient.init).inObjectScope(.container)
  }

  private func registerServices() {
    autoregister(URLSession.self) { URLSession.shared }
    autoregister(SKPaymentQueue.self) { SKPaymentQueue() }
  }

  private func registerWorkers() {

  }

  private func registerCommons() {
    autoregister(NotificationCenter.self) { NotificationCenter.default }
  }

  private func registerDatabase() {
    autoregister(UserDefaults.self) { UserDefaults.standard }
  }
}
