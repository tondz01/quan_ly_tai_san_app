// ignore_for_file: unintended_html_in_doc_comment

import 'dart:convert';
import 'dart:developer';

/// Utility class for handling API responses and converting them to model objects
class ResponseParser {
  /// Parse API response data into a list of model objects
  /// 
  /// [jsonList] - JSON response data (can be List, Map or String)
  /// [fromJson] - Function to convert a Map<String, dynamic> to a model object
  /// 
  /// Returns a list of model objects of type T
  static List<T> parseToList<T>(
    dynamic jsonData,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (jsonData == null) return [];

    // Handle string response
    if (jsonData is String) {
      try {
        jsonData = jsonDecode(jsonData);
      } catch (e) {
        log("JSON decode error: $e");
        return [];
      }
    }

    // Handle different response formats
    if (jsonData is List) {
      return jsonData
          .map<T>((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else if (jsonData is Map) {
      // Check if response has nested data in result.data format
      if (jsonData.containsKey('result') && 
          jsonData['result'] is Map && 
          jsonData['result'].containsKey('data') &&
          jsonData['result']['data'] is List) {
        return jsonData['result']['data']
            .map<T>((item) => fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        // Single object response
        return [fromJson(Map<String, dynamic>.from(jsonData))];
      }
    }
    
    return [];
  }

  /// Parse API response into a single model object
  /// 
  /// [jsonData] - JSON response data (can be Map or String)
  /// [fromJson] - Function to convert a Map<String, dynamic> to a model object
  /// 
  /// Returns a model object of type T or null if parsing fails
  static T? parseToObject<T>(
    dynamic jsonData,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (jsonData == null) return null;

    // Handle string response
    if (jsonData is String) {
      try {
        jsonData = jsonDecode(jsonData);
      } catch (e) {
        log("JSON decode error: $e");
        return null;
      }
    }

    // Handle different response formats
    if (jsonData is Map) {
      // Check if response has nested data in result.data format
      if (jsonData.containsKey('result') && 
          jsonData['result'] is Map && 
          jsonData['result'].containsKey('data')) {
        var data = jsonData['result']['data'];
        if (data is Map) {
          return fromJson(Map<String, dynamic>.from(data));
        }
      } else {
        // Direct object response
        return fromJson(Map<String, dynamic>.from(jsonData));
      }
    }
    
    return null;
  }
} 