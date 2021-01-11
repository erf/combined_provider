import 'package:riverpod/riverpod.dart';

final loadedProvider =
    Provider.family<bool, List<ProviderBase>>((ref, providerList) {
  for (final provider in providerList) {
    if (provider is FutureProvider) {
      if (ref.watch(provider) is! AsyncData) {
        return false;
      }
    } else if (provider is StreamProvider) {
      if (ref.watch(provider) is! AsyncData) {
        return false;
      }
    }
  }
  return true;
});