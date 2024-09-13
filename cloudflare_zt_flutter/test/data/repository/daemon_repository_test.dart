import 'package:cloudflare_zt_flutter/data/repositories/daemon_connection_repository.dart';
import 'package:cloudflare_zt_flutter/domain/errors/data_source_exception.dart';
import 'package:cloudflare_zt_flutter/domain/models/daemon/daemon_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/default_mocks.dart';

void main() {
  setUp(() async {
    await setupDefaultMocksBehavior();
  });

  group('DaemonConnectionRepository', () {
    const authToken = '245346437489485';

    test('connect calls connect on SocketService with correct token', () async {
      final repository = DaemonConnectionRepository(mockSocketService);

      await repository.connect(authToken);

      verify(() => mockSocketService.connect(authToken)).called(1);
    });

    test('disconnect calls disconnect on SocketService', () async {
      final repository = DaemonConnectionRepository(mockSocketService);

      await repository.disconnect();

      verify(() => mockSocketService.disconnect()).called(1);
    });

    test('getStatus returns DaemonStatus from SocketService', () async {
      final repository = DaemonConnectionRepository(mockSocketService);
      final status = await repository.getStatus();

      expect(status, equals(const DaemonStatus.connected()));
      verify(() => mockSocketService.getStatus()).called(1);
    });

    test('connect throws error when SocketService.connect fails', () async {
      when(() => mockSocketService.connect(authToken))
          .thenThrow(const DataSourceException.serverError(message: 'Connection failed'));

      final repository = DaemonConnectionRepository(mockSocketService);

      expect(() async => await repository.connect(authToken),
          throwsA(isA<DataSourceException>().having((e) => e.message, 'message', 'Connection failed')));
    });
  });
}
