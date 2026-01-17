import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/finance_repository.dart';
import '../repositories/greenpay_repository.dart';
import '../../../core/models/admin_fee.dart';
import '../../../core/models/energy_usage.dart';
import '../../../core/models/energy_coach.dart';
import '../../../core/models/green_pay.dart';

final financeRepositoryProvider = Provider((ref) => FinanceRepository());
final greenPayRepositoryProvider = Provider((ref) => GreenPayRepository());

final latestFeeProvider = FutureProvider<AdminFee>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getLatestFee();
});

final energyHistoryProvider = FutureProvider<List<EnergyUsage>>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getEnergyHistory();
});

final energyCoachProvider = FutureProvider<EnergyCoachResponse>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.getEnergyCoachTips();
});

final walletProvider = FutureProvider<Wallet>((ref) async {
  final repository = ref.watch(greenPayRepositoryProvider);
  return repository.getWallet();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final repository = ref.watch(greenPayRepositoryProvider);
  return repository.getTransactions();
});
