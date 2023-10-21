import SwiftUI
import GoTrue

@Observable final class AuthController {
  var session: Session?

  var currentUserID: UUID {
    guard let id = session?.user.id else {
      preconditionFailure("Required session.")
    }

    return id
  }
}
