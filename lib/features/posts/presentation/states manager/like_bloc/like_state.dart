part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  const LikeState();
}

class LikeInitial extends LikeState {
  @override
  List<Object> get props => [];
}

class LikeLoading extends LikeState {
  @override
  List<Object> get props => [];
}

class LikeAdded extends LikeState {
  final PostModel post;

  const LikeAdded({required this.post});

  @override
  List<Object> get props => [post];
}

class LikeRemoved extends LikeState {
  final PostModel post;

  const LikeRemoved({required this.post});

  @override
  List<Object> get props => [post];
}

class ErrorLikeState extends LikeState {
  final String message;

  const ErrorLikeState({required this.message});

  @override
  List<Object> get props => [message];
}
