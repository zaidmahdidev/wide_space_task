part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {
  const CommentsState();

  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class LoadingCommentsState extends CommentsState {}

class LoadedCommentsState extends CommentsState {
  final List<CommentModel> comments;

  const LoadedCommentsState({required this.comments});

  @override
  List<Object> get props => [comments];
}

class ErrorCommentsState extends CommentsState {
  final String message;

  const ErrorCommentsState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingCommentsAddState extends CommentsState {}

class LoadingCommentsDeleteState extends CommentsState {}

class LoadingCommentsUpdateState extends CommentsState {}

class ErrorAddDeleteUpdateState extends CommentsState {
  final String message;

  const ErrorAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}

class CommentAddState extends CommentsState {
  final String message;
  final CommentModel comment;

  const CommentAddState({required this.message, required this.comment});

  @override
  List<Object> get props => [message, comment];
}

class MessageCommentDeleteState extends CommentsState {
  final String message;
  final int index;

  const MessageCommentDeleteState({required this.message, required this.index});

  @override
  List<Object> get props => [message, index];
}

class MessageCommentUpdateState extends CommentsState {
  final String message;
  final int index;
  final String newBody;

  const MessageCommentUpdateState(
      {required this.message, required this.index, required this.newBody});

  @override
  List<Object> get props => [message, index, newBody];
}
