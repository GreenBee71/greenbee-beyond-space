import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

final iotServiceProvider = Provider((ref) => IotService(ref.watch(dioProvider)));

class IotService {
  final Dio _dio;
  IotService(this._dio);

  Future<List<Map<String, dynamic>>> getMyDevices() async {
    final response = await _dio.get('/iot/devices');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> registerDevice({
    required String name,
    required String type,
    required String provider,
    required Map<String, dynamic> config,
  }) async {
    final response = await _dio.post('/iot/devices', data: {
      'device_name': name,
      'device_type': type,
      'provider_name': provider,
      'connection_config': config,
    });
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> removeDevice(int id) async {
    await _dio.delete('/iot/devices/$id');
  }

  Future<List<Map<String, dynamic>>> getScenarios() async {
    final response = await _dio.get('/iot/scenarios');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> triggerScenario(int id) async {
    await _dio.post('/iot/scenarios/$id/trigger');
  }

  Future<Map<String, dynamic>> getGardenStatus() async {
    final response = await _dio.get('/iot/garden-status');
    return Map<String, dynamic>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getSuggestions() async {
    final response = await _dio.get('/iot/suggestions');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getHomeEquipments() async {
    final response = await _dio.get('/iot/home-equipments');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> controlHomeEquipment(int id, Map<String, dynamic> action) async {
    await _dio.post('/iot/home-equipments/$id/control', data: action);
  }
}

final myIotDevicesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(iotServiceProvider).getMyDevices();
});

final iotScenariosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(iotServiceProvider).getScenarios();
});

final gardenStatusProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(iotServiceProvider).getGardenStatus();
});

final conciergeSuggestionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(iotServiceProvider).getSuggestions();
});

final homeEquipmentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(iotServiceProvider).getHomeEquipments();
});
