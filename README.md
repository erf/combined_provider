# combined_provider

A `riverpod` provider for watching a list of providers and getting an `AsyncData<List>` result when all objects is not in either an `AsyncError` or `AsyncLoading` state.

Also includes a provider for checking if a all providers are in the `AsyncData` state.

Providers:

- `combined_provider.dart`
- `loaded_provider.dart`

Pass providers using the `familiy` attribute.

See [example](example).
