class APIEndpoints {
  // The endpoint for retrieving the authentication token
  static const String registration = '';
}

class APIResponseCodes {
  static const int ok = 200;
  static const int multipleChoices = 300;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
}
