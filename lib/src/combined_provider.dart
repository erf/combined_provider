import 'package:riverpod/riverpod.dart';

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
    if (provider is StreamProvider) {
      result.add(ref.watch(provider).data.value);
    } else if (provider is FutureProvider) {
      result.add(ref.watch(provider).data.value);
    } else if (provider is StateProvider) {
      result.add(ref.watch(provider).state);
    } else if (provider is StateNotifier) {
      result.add(ref.watch(provider).state);
    } else if (provider is StateNotifierProvider) {
      result.add(ref.watch(provider.state));
    } else if (provider is Provider) {
      result.add(ref.watch(provider));
    } else {
      final error = 'Provider ${provider.runtimeType} is not supported';
      return AsyncError(error);
    }
  }
  return AsyncData(result);
});
