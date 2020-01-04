/// A contract for which a chat service must adhere to
abstract class IChatService {
  /// Attempts to log in the user anonymously
  Future<bool> loginUser();
}
