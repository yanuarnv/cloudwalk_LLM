part of 'layout_editor_bloc.dart';

class LayoutState extends Equatable {
  final ScaffoldEntity? data;
  final bool isLoading;
  final String hasError;

  LayoutState({
    this.data,
    this.isLoading = false,
    this.hasError = '',
  });

  LayoutState copyWith({
    ScaffoldEntity? data,
    bool? isLoading,
    String? error,
  }) {
    return LayoutState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      hasError: error ?? hasError,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [data, isLoading, hasError];
}
