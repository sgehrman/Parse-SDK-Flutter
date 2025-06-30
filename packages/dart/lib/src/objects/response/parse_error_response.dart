part of flutter_parse_sdk;

/// Handles any errors returned in response
ParseResponse buildErrorResponse(
    ParseResponse response, ParseNetworkResponse apiResponse) {
  try {
    // ### SNG: apiResponse.data is expected to be a JSON string
    // but sometimes you get:
    // <html>
    // <head><title>502 Bad Gateway</title></head>
    // this throws an exception when trying to decode it
    final Map<String, dynamic> responseData = json.decode(apiResponse.data);

    response.error = ParseError(
      code: responseData[keyCode] ?? ParseError.otherCause,
      message: responseData[keyError].toString(),
    );

    response.statusCode = responseData[keyCode] ?? ParseError.otherCause;
  } catch (err) {
    response.error = ParseError(
      code: ParseError.otherCause,
      message: 'buildErrorResponse: Unexpected HTML response received.'
          'Error: ${err.toString()}, This usually indicates a 502 Bad Gateway.',
    );

    response.statusCode = ParseError.otherCause;
  }

  return response;
}
