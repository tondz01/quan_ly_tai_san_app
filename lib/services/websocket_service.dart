import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  StompClient? _stompClient;
  bool _isConnected = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  int _endpointIndex = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool get isConnected => _isConnected;

  // Public method to test WebSocket connection
  Future<void> testConnection(String serverUrl) async {
    print('Testing WebSocket connection to: $serverUrl');
    await testWebSocketConnection(serverUrl);
  }

  // Convert HTTP/HTTPS URL to WebSocket URL
  String _convertToWebSocketUrl(String serverUrl) {
    if (serverUrl.startsWith('https://')) {
      return serverUrl.replaceFirst('https://', 'wss://');
    } else if (serverUrl.startsWith('http://')) {
      return serverUrl.replaceFirst('http://', 'ws://');
    } else if (serverUrl.startsWith('wss://') || serverUrl.startsWith('ws://')) {
      return serverUrl;
    } else {
      // Default to wss if no protocol specified
      return 'wss://$serverUrl';
    }
  }

  // Try different WebSocket endpoint paths
  List<String> _getWebSocketEndpoints(String baseUrl) {
    return [
      baseUrl, // Direct connection
      '$baseUrl/ws', // Common WebSocket endpoint
      '$baseUrl/websocket', // Alternative endpoint
      '$baseUrl/stomp', // STOMP specific endpoint
      '$baseUrl/stomp/websocket', // Spring Boot default STOMP endpoint
    ];
  }

  // Attempt to reconnect with exponential backoff
  void _attemptReconnect(
    String serverUrl,
    String companyId,
    String userId,
    Function(NotificationData)? onNotification,
  ) {
    List<String> endpoints = _getWebSocketEndpoints(serverUrl);
    
    // If we've tried all endpoints, reset and try again
    if (_endpointIndex >= endpoints.length - 1) {
      _endpointIndex = 0;
      _reconnectAttempts++;
    } else {
      _endpointIndex++;
    }
    
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('Max reconnection attempts reached. Giving up.');
      print('Tried all endpoints: ${endpoints.join(", ")}');
      _printWebSocketTroubleshootingInfo(serverUrl);
      return;
    }

    print('Attempting to reconnect (attempt $_reconnectAttempts/$_maxReconnectAttempts, endpoint ${_endpointIndex + 1}/${endpoints.length})');
    
    Future.delayed(_reconnectDelay * _reconnectAttempts, () {
      if (!_isConnected && !_isConnecting) {
        connect(
          serverUrl: serverUrl,
          companyId: companyId,
          userId: userId,
          onNotification: onNotification,
        );
      }
    });
  }

  // Khởi tạo local notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(initializationSettings);
  }

  // Kết nối WebSocket
  Future<void> connect({
    required String serverUrl,
    required String companyId,
    required String userId,
    Function(NotificationData)? onNotification,
  }) async {
    if (_isConnecting) {
      print('WebSocket connection already in progress');
      return;
    }

    _isConnecting = true;
    
    try {
      // Get list of possible WebSocket endpoints
      List<String> endpoints = _getWebSocketEndpoints(serverUrl);
      String wsUrl = _convertToWebSocketUrl(endpoints[_endpointIndex]);
      print('Connecting to WebSocket endpoint ${_endpointIndex + 1}/${endpoints.length}: $wsUrl');
      print('Company ID: $companyId, User ID: $userId');
      
      final config = StompConfig(
        url: wsUrl,
        // Add STOMP configuration for better compatibility
        stompConnectHeaders: {
          'accept-version': '1.1,1.0',
          'heart-beat': '10000,10000',
        },
        webSocketConnectHeaders: {
          'Origin': serverUrl,
        },
        onConnect: (StompFrame frame) {
          print('WebSocket Connected: $frame');
          _isConnected = true;
          _isConnecting = false;
          _reconnectAttempts = 0; // Reset reconnect attempts on successful connection

          // Subscribe to global notifications
          _stompClient!.subscribe(
            destination: '/topic/notifications',
            callback: (frame) {
              final notification = NotificationData.fromJson(
                jsonDecode(frame.body!),
              );
              _handleNotification(notification, onNotification);
            },
          );

          // Subscribe to company notifications
          _stompClient!.subscribe(
            destination: '/topic/company/$companyId',
            callback: (frame) {
              final notification = NotificationData.fromJson(
                jsonDecode(frame.body!),
              );
              _handleNotification(notification, onNotification);
            },
          );

          // Subscribe to user notifications
          _stompClient!.subscribe(
            destination: '/user/queue/notifications',
            callback: (frame) {
              final notification = NotificationData.fromJson(
                jsonDecode(frame.body!),
              );
              _handleNotification(notification, onNotification);
            },
          );
        },
        onWebSocketError: (dynamic error) {
          print('WebSocket Error: $error');
          print('Error type: ${error.runtimeType}');
          if (error.toString().contains('Event')) {
            print('This appears to be a browser WebSocket error. Check if the server supports WebSocket connections.');
          }
          _isConnected = false;
          _isConnecting = false;
          _attemptReconnect(serverUrl, companyId, userId, onNotification);
        },
        onStompError: (StompFrame frame) {
          print('STOMP Error: ${frame.body}');
          print('STOMP Error Headers: ${frame.headers}');
          _isConnected = false;
          _isConnecting = false;
          _attemptReconnect(serverUrl, companyId, userId, onNotification);
        },
        onDisconnect: (StompFrame frame) {
          print('WebSocket Disconnected: $frame');
          _isConnected = false;
          _isConnecting = false;
          // Only attempt reconnect if it wasn't a manual disconnect
          if (_reconnectAttempts < _maxReconnectAttempts) {
            _attemptReconnect(serverUrl, companyId, userId, onNotification);
          }
        },
      );

      _stompClient = StompClient(config: config);
      _stompClient!.activate();
    } catch (e) {
      print('Connection Error: $e');
      _isConnected = false;
      _isConnecting = false;
      _attemptReconnect(serverUrl, companyId, userId, onNotification);
    }
  }

  // Xử lý thông báo
  void _handleNotification(
    NotificationData notification,
    Function(NotificationData)? onNotification,
  ) {
    print('Received notification: ${notification.title}');

    // Gọi callback nếu có
    onNotification?.call(notification);

    // Hiển thị local notification
    _showLocalNotification(notification);
  }

  // Hiển thị local notification
  Future<void> _showLocalNotification(NotificationData notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'quanlytaisan_notifications',
          'Quản lý tài sản thông báo',
          channelDescription: 'Thông báo từ hệ thống quản lý tài sản',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notifications.show(
      notification.hashCode,
      notification.title,
      notification.message,
      platformChannelSpecifics,
    );
  }

  // Ngắt kết nối
  void disconnect() {
    _reconnectAttempts = _maxReconnectAttempts; // Prevent reconnection
    _stompClient?.deactivate();
    _isConnected = false;
    _isConnecting = false;
  }

  // Print troubleshooting information
  void _printWebSocketTroubleshootingInfo(String serverUrl) {
    print('\n=== WebSocket Connection Troubleshooting ===');
    print('Server URL: $serverUrl');
    print('Possible issues:');
    print('1. Server may not support WebSocket connections');
    print('2. WebSocket endpoint might be different from expected');
    print('3. Server might require authentication headers');
    print('4. Network firewall might be blocking WebSocket connections');
    print('5. Server might be down or unreachable');
    print('\nSuggested solutions:');
    print('1. Check with server administrator about WebSocket support');
    print('2. Verify the correct WebSocket endpoint path');
    print('3. Consider using HTTP polling as fallback');
    print('4. Check network connectivity and firewall settings');
    print('===============================================\n');
  }

  // Check if WebSocket connection is possible
  Future<bool> testWebSocketConnection(String serverUrl) async {
    try {
      List<String> endpoints = _getWebSocketEndpoints(serverUrl);
      for (String endpoint in endpoints) {
        String wsUrl = _convertToWebSocketUrl(endpoint);
        print('Testing WebSocket endpoint: $wsUrl');
        
        // Create a test connection
        final testConfig = StompConfig(
          url: wsUrl,
          onConnect: (frame) {
            print('Test connection successful to: $wsUrl');
          },
          onWebSocketError: (error) {
            print('Test connection failed to: $wsUrl - $error');
          },
        );
        
        final testClient = StompClient(config: testConfig);
        testClient.activate();
        
        // Wait a bit for connection attempt
        await Future.delayed(Duration(seconds: 2));
        testClient.deactivate();
      }
      return true;
    } catch (e) {
      print('WebSocket test failed: $e');
      return false;
    }
  }
}

// Model cho thông báo
class NotificationData {
  final String title;
  final String message;
  final String type;
  final String timestamp;
  final String? targetId;

  NotificationData({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.targetId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] ?? '',
      targetId: json['targetId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'targetId': targetId,
    };
  }
}
