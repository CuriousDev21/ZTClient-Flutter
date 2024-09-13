import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'dart:math' as math;

class FormattedNetworkLogger extends Interceptor {
  /// Print request [Options]
  final bool logRequest;

  /// Print request header [Options.headers]
  final bool logRequestHeader;

  /// Print request data [Options.data]
  final bool logRequestBody;

  /// Print [Response.data]
  final bool logResponseBody;

  /// Print [Response.headers]
  final bool logResponseHeader;

  /// Print error message
  final bool errorLog;

  /// Initial spacing factor count to logPrint json response
  static const int kSpacingFactor = 1;

  /// 1 tab length
  static const String contentTabSpace = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  /// Maximum characters of the response body to log
  final int maxLogLength;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  final void Function(Object object) outputLog;

  FormattedNetworkLogger(
      {this.logRequest = true,
      this.logRequestHeader = false,
      this.logRequestBody = false,
      this.logResponseHeader = false,
      this.logResponseBody = true,
      this.errorLog = true,
      this.maxWidth = 90,
      this.maxLogLength = 1000,
      this.compact = true,
      this.outputLog = print});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      _printRequestHeader(options);
    }
    if (logRequestHeader) {
      _printMapAsTable(options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
      _printMapAsTable(requestHeaders, header: 'Headers');
      _printMapAsTable(options.extra, header: 'Extras');
    }
    if (logRequestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
        } else {
          _printBlock(data.toString());
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (errorLog) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
            header: 'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
            text: uri.toString());
        if (err.response != null && err.response?.data != null) {
          outputLog('╔ ${err.type.toString()}');
          _printResponse(err.response!);
        }
        _printLine('╚');
        outputLog('');
      } else {
        _printBoxed(header: 'DioError ║ ${err.type}', text: err.message);
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (logResponseHeader) {
      final responseHeaders = <String, String>{};
      response.headers.forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (logResponseBody) {
      outputLog('╔ Body');
      outputLog('║');
      _truncateAndPrintResponse(response);
      outputLog('║');
      _printLine('╚');
    }
    super.onResponse(response, handler);
  }

  void _printBoxed({String? header, String? text}) {
    outputLog('');
    outputLog('╔╣ $header');
    outputLog('║  $text');
    _printLine('╚');
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map);
      } else if (response.data is Uint8List) {
        outputLog('║${_indent()}[');
        _printUint8List(response.data as Uint8List);
        outputLog('║${_indent()}]');
      } else if (response.data is List) {
        outputLog('║${_indent()}[');
        _printList(response.data as List);
        outputLog('║${_indent()}]');
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header: 'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}', text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) => outputLog('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      outputLog(pre);
      _printBlock(msg);
    } else {
      outputLog('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      outputLog((i >= 0 ? '║ ' : '') + msg.substring(i * maxWidth, math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = kSpacingFactor]) => contentTabSpace * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kSpacingFactor,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kSpacingFactor;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) outputLog('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          outputLog('║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          outputLog('║${_indent(tabs)} $key: {');
          _printPrettyMap(value, initialTab: tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          outputLog('║${_indent(tabs)} $key: ${value.toString()}');
        } else {
          outputLog('║${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs);
          outputLog('║${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            outputLog(
                '║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          outputLog('║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    outputLog('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = kSpacingFactor}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          outputLog('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, initialTab: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        outputLog('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  void _printUint8List(Uint8List list, {int tabs = kSpacingFactor}) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    for (var element in chunks) {
      outputLog('║${_indent(tabs)} ${element.join(", ")}');
    }
  }

  bool _canFlattenMap(Map map) {
    return map.values.where((dynamic val) => val is Map || val is List).isEmpty && map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    outputLog('╔ $header ');
    map.forEach((dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }

  void _truncateAndPrintResponse(Response response) {
    if (response.data != null) {
      String responseData = response.data.toString();
      if (responseData.length > maxLogLength) {
        // Truncate the response data if it's too long
        responseData = '${responseData.substring(0, maxLogLength)}...<truncated>';
      }
      _printBlock(responseData);
    }
  }
}
