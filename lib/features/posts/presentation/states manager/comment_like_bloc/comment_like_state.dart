part of 'comment_like_bloc.dart';

abstract class CommentLikeState extends Equatable {
  const CommentLikeState();
}

class LikeInitial extends CommentLikeState {
  @override
  List<Object> get props => [];
}

class LikeLoading extends CommentLikeState {
  @override
  List<Object> get props => [];
}

class DislikeLoading extends CommentLikeState {
  @override
  List<Object> get props => [];
}

class LikeAdded extends CommentLikeState {
  final CommentModel comment;

  const LikeAdded({required this.comment});

  @override
  List<Object> get props => [comment];
}

class DislikeAdded extends CommentLikeState {
  final CommentModel comment;

  const DislikeAdded({required this.comment});

  @override
  List<Object> get props => [comment];
}

class LikeRemoved extends CommentLikeState {
  final CommentModel comment;

  const LikeRemoved({required this.comment});

  @override
  List<Object> get props => [comment];
}

class DislikeRemoved extends CommentLikeState {
  final CommentModel comment;

  const DislikeRemoved({required this.comment});

  @override
  List<Object> get props => [comment];
}

class ErrorLikeState extends CommentLikeState {
  final String message;

  const ErrorLikeState({required this.message});

  @override
  List<Object> get props => [message];
}
