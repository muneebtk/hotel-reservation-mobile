import 'dart:async';
import 'dart:io';

String handleHttpException(e) {
  if (e is SocketException) {
    // No internet connection
    return "Unable to connect. Please check your internet connection.";
  } else if (e is TimeoutException) {
    // Request timed out
    return "The request timed out. Please try again later.";
  } else if (e is HttpException) {
    // Server-related issues
    return "We’re having trouble reaching the server. Please try again.";
  } else if (e is FormatException) {
    // Invalid response format
    return "Unexpected server response. Please try again.";
  } else {
    // Generic error message for unexpected errors
    return "An unexpected error occurred. Please try again.";
  }
}
