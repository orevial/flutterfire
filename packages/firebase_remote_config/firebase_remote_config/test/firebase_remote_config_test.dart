// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mock.dart';

MockFirebaseRemoteConfig mockRemoteConfigPlatform = MockFirebaseRemoteConfig();

void main() {
  setupFirebaseRemoteConfigMocks();

  late RemoteConfig remoteConfig;

  DateTime mockLastFetchTime;
  RemoteConfigFetchStatus mockLastFetchStatus;
  RemoteConfigSettings mockRemoteConfigSettings;
  late Map<String, RemoteConfigValue> mockParameters;
  late Map<String, dynamic> mockDefaultParameters;
  RemoteConfigValue mockRemoteConfigValue;

  group('$RemoteConfig', () {
    FirebaseRemoteConfigPlatform.instance = mockRemoteConfigPlatform;

    setUpAll(() async {
      print('In setup');
      final app = await Firebase.initializeApp();
      print('Got app: $app');
      remoteConfig = RemoteConfig.instance;

      mockLastFetchTime = DateTime(2020);
      mockLastFetchStatus = RemoteConfigFetchStatus.noFetchYet;
      mockRemoteConfigSettings = RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      );
      mockParameters = <String, RemoteConfigValue>{};
      mockDefaultParameters = <String, dynamic>{};
      mockRemoteConfigValue = RemoteConfigValue(
        <int>[],
        ValueSource.valueStatic,
      );

      when(mockRemoteConfigPlatform.instanceFor(
              app: app, pluginConstants: anyNamed('pluginConstants')))
          .thenAnswer((_) => mockRemoteConfigPlatform);

      print('Got app: $app - mockRemote: $mockRemoteConfigPlatform');
      mockRemoteConfigPlatform.delegateFor(app: app);
      print('In erE?');

      when(mockRemoteConfigPlatform.delegateFor(
        app: app,
      )).thenReturn(mockRemoteConfigPlatform);

      when(mockRemoteConfigPlatform.setInitialValues(remoteConfigValues: {}))
          .thenAnswer((_) => mockRemoteConfigPlatform);

      when(mockRemoteConfigPlatform.lastFetchTime)
          .thenReturn(mockLastFetchTime);

      when(mockRemoteConfigPlatform.lastFetchStatus)
          .thenReturn(mockLastFetchStatus);

      when(mockRemoteConfigPlatform.settings)
          .thenReturn(mockRemoteConfigSettings);

      // when(mockRemoteConfigPlatform.setConfigSettings(any!))
      //     .thenAnswer(((_) => null) as Future<void> Function(Invocation));

      when(mockRemoteConfigPlatform.activate())
          .thenAnswer((_) => Future.value(true));

      when(mockRemoteConfigPlatform.ensureInitialized())
          .thenAnswer((_) => Future.value());

      when(mockRemoteConfigPlatform.fetch()).thenAnswer((_) => Future.value());

      when(mockRemoteConfigPlatform.fetchAndActivate())
          .thenAnswer((_) => Future.value(true));

      when(mockRemoteConfigPlatform.getAll()).thenReturn(mockParameters);

      when(mockRemoteConfigPlatform.getBool('foo')).thenReturn(true);

      when(mockRemoteConfigPlatform.getInt('foo')).thenReturn(8);

      when(mockRemoteConfigPlatform.getDouble('foo')).thenReturn(8.8);

      when(mockRemoteConfigPlatform.getString('foo')).thenReturn('bar');

      when(mockRemoteConfigPlatform.getValue('foo'))
          .thenReturn(mockRemoteConfigValue);

      // when(mockRemoteConfigPlatform.setDefaults(any!))
      //     .thenAnswer((_) => Future.value());
    });

    test('doubleInstance', () async {
      final List<RemoteConfig> remoteConfigs = <RemoteConfig>[
        RemoteConfig.instance,
        RemoteConfig.instance,
      ];
      expect(remoteConfigs[0], remoteConfigs[1]);
    });

    group('lastFetchTime', () {
      test('get lastFetchTime', () {
        remoteConfig.lastFetchTime;
        verify(mockRemoteConfigPlatform.lastFetchTime);
      });
    });

    group('lastFetchStatus', () {
      test('get lastFetchStatus', () {
        remoteConfig.lastFetchStatus;
        verify(mockRemoteConfigPlatform.lastFetchStatus);
      });
    });

    group('settings', () {
      test('get settings', () {
        remoteConfig.settings;
        verify(mockRemoteConfigPlatform.settings);
      });

      test('set settings', () async {
        final remoteConfigSettings = RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 8),
          minimumFetchInterval: Duration.zero,
        );
        await remoteConfig.setConfigSettings(remoteConfigSettings);
        verify(
            mockRemoteConfigPlatform.setConfigSettings(remoteConfigSettings));
      });
    });

    group('activate()', () {
      test('should call delegate method', () async {
        await remoteConfig.activate();
        verify(mockRemoteConfigPlatform.activate());
      });
    });

    group('ensureInitialized()', () {
      test('should call delegate method', () async {
        await remoteConfig.ensureInitialized();
        verify(mockRemoteConfigPlatform.ensureInitialized());
      });
    });

    group('fetch()', () {
      test('should call delegate method', () async {
        await remoteConfig.fetch();
        verify(mockRemoteConfigPlatform.fetch());
      });
    });

    group('fetchAndActivate()', () {
      test('should call delegate method', () async {
        await remoteConfig.fetchAndActivate();
        verify(mockRemoteConfigPlatform.fetchAndActivate());
      });
    });

    group('getAll()', () {
      test('should call delegate method', () {
        remoteConfig.getAll();
        verify(mockRemoteConfigPlatform.getAll());
      });
    });

    group('getBool()', () {
      test('should call delegate method', () {
        remoteConfig.getBool('foo');
        verify(mockRemoteConfigPlatform.getBool('foo'));
      });
    });

    group('getInt()', () {
      test('should call delegate method', () {
        remoteConfig.getInt('foo');
        verify(mockRemoteConfigPlatform.getInt('foo'));
      });
    });

    group('getDouble()', () {
      test('should call delegate method', () {
        remoteConfig.getDouble('foo');
        verify(mockRemoteConfigPlatform.getDouble('foo'));
      });
    });

    group('getString()', () {
      test('should call delegate method', () {
        remoteConfig.getString('foo');
        verify(mockRemoteConfigPlatform.getString('foo'));
      });
    });

    group('getValue()', () {
      test('should call delegate method', () {
        remoteConfig.getValue('foo');
        verify(mockRemoteConfigPlatform.getValue('foo'));
      });
    });

    group('setDefaults()', () {
      test('should call delegate method', () {
        remoteConfig.setDefaults(mockParameters);
        verify(mockRemoteConfigPlatform.setDefaults(mockDefaultParameters));
      });
    });
  });
}

class MockFirebaseRemoteConfig extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        TestFirebaseRemoteConfigPlatform {
  MockFirebaseRemoteConfig();
}

class TestFirebaseRemoteConfigPlatform extends FirebaseRemoteConfigPlatform {
  TestFirebaseRemoteConfigPlatform() : super(appInstance: null);

  void instanceFor(
      {required FirebaseApp app, Map<dynamic, dynamic>? pluginConstants}) {}

  @override
  FirebaseRemoteConfigPlatform delegateFor({required FirebaseApp app}) {
    print('This is :$this');
    return this;
  }

  @override
  FirebaseRemoteConfigPlatform setInitialValues(
      {required Map<dynamic, dynamic> remoteConfigValues}) {
    return this;
  }
}
