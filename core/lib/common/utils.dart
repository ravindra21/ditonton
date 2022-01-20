import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/io_client.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<SecurityContext> get globalContext async {
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  try {
    final sslCert = await rootBundle.load('certificates/cert.crt');
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  } on TlsException catch (e) {
    if (e.osError?.message != null &&
        e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
      log('createHttpClient() - cert already trusted! Skipping.');
    } else {
      log('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
      rethrow;
    }
  } catch (e) {
    log('unexpected error $e');
    rethrow;
  }

  return securityContext;
}

Future<IOClient> get ioClient async {
  try {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => throw false;
    return IOClient(client);
  } catch (e) {
    log('unexpected error $e');
    rethrow;
  }
}
