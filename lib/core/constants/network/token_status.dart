/// Represents the status of the access token.
enum TokenStatus {
  /// Can use old access token.
  oldAccess,

  /// Should get the new access token.
  newAccess,

  /// No token, should direct the user to the login screen.
  noToken,
}
