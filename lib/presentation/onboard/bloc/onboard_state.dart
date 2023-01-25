part of 'onboard_bloc.dart';

class OnboardState extends Equatable {
  final bool? isWatch;
  final bool isLast;

  const OnboardState({this.isWatch, required this.isLast});

  factory OnboardState.init(){
    return const OnboardState(isLast: false);
  }

  OnboardState copyWith({
    bool? isWatch,
    bool? isLast,
  }) {
    return OnboardState(
      isWatch: isWatch ?? this.isWatch,
      isLast: isLast ?? this.isLast,
    );
  }

  @override
  List<Object?> get props => [isWatch, isLast];
}
