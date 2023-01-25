part of 'dialog_bloc.dart';

class DialogState extends Equatable {
  final String title;
  final String content;
  final String button;
  final DialogStatus status;

  const DialogState({
    required this.title,
    required this.content,
    required this.button,
    required this.status,
  });

  factory DialogState.init(){
    return const DialogState(
      title: '알림',
      content: '',
      button: '확인',
      status: DialogStatus.init,
    );
  }

  DialogState copyWith({
    String? title,
    String? content,
    String? button,
    DialogStatus? status,
  }) {
    return DialogState(
      title: title ?? this.title,
      content: content ?? this.content,
      button: button ?? this.button,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [title, content, button, status];
}

enum DialogStatus {
  init,
  done,
}