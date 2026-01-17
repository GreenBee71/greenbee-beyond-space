import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../repositories/living_repository.dart';
import '../../../core/models/visitor.dart';
import '../../../core/models/vote.dart';

final livingRepositoryProvider = Provider((ref) => LivingRepository());

final livingServiceProvider = Provider((ref) => LivingService(ref.watch(dioProvider)));

class LivingService {
  final Dio _dio;
  LivingService(this._dio);

  Future<List<Map<String, dynamic>>> getFacilities() async {
    final response = await _dio.get('/living/facilities');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getEVChargers() async {
    final response = await _dio.get('/living/ev-chargers');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getDeliveries() async {
    final response = await _dio.get('/living/deliveries');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getChallenges() async {
    final response = await _dio.get('/living/challenges');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getShareItems() async {
    final response = await _dio.get('/living/share-items');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getTalents() async {
    final response = await _dio.get('/living/talent-exchanges');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getSocialClubs() async {
    final response = await _dio.get('/living/social-clubs');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> requestHomeCare(Map<String, dynamic> data) async {
    await _dio.post('/living/home-care', data: data);
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    if (query.isEmpty) return [];
    // Simulation: in production this would call a vector search endpoint
    final response = await _dio.get('/living/share-items');
    final items = List<Map<String, dynamic>>.from(response.data);
    return items.where((item) => 
      item['title'].contains(query) || item['category'].contains(query)
    ).toList();
  }
}

final visitorsProvider = FutureProvider<List<Visitor>>((ref) async {
  return ref.watch(livingRepositoryProvider).getVisitors();
});

final activeVotesProvider = FutureProvider<List<Vote>>((ref) async {
  return ref.watch(livingRepositoryProvider).getVotes();
});

final facilitiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getFacilities();
});

final evChargersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getEVChargers();
});

final deliveriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getDeliveries();
});

final challengesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getChallenges();
});

final shareItemsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getShareItems();
});

final talentExchangeProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getTalents();
});

final socialClubsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(livingServiceProvider).getSocialClubs();
});

final searchQueryProvider = StateProvider<String>((ref) => "");

final searchResultsProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(livingServiceProvider).searchItems(query);
});
