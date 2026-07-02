/// HTTP headers for recipe photo CDNs that require a User-Agent.
Map<String, String>? recipeImageHttpHeaders(String url) {
  if (url.contains('wikimedia.org')) {
    return const {'User-Agent': 'SpiceRoute/1.0 (https://spiceroute.app)'};
  }
  return null;
}
