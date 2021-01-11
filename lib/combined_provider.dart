library combined_provider;

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

final combinedProvider =
    Provider.family<AsyncValue, List<ProviderBase>>((ref, providerList) {
  // watch for errors
  for (final provider in providerList) {
    final value = ref.watch(provider);
    if (provider is FutureProvider) {
      if (value is AsyncError) {
        return value;
      }
    } else if (provider is StreamProvider) {
      if (value is AsyncError) {
        return value;
      }
    }
  }

  // else watch for loading
  for (final provider in providerList) {
    final value = ref.watch(provider);
    if (provider is FutureProvider) {
      if (value is AsyncLoading) {
        return value;
      }
    } else if (provider is StreamProvider) {
      if (value is AsyncLoading) {
        return value;
      }
    }
  }

  // else collect data
  final result = [];
  for (final provider in providerList) {
    result.add(ref.watch(provider));
  }
  return AsyncData(result);
});
