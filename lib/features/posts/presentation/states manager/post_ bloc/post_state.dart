part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class LoadingPostState extends PostState {
  @override
  List<Object?> get props => [];
}

class LoadedPostState extends PostState {
  final PostModel post;

  const LoadedPostState({required this.post});

  @override
  List<Object> get props => [post];
}

class ErrorPostState extends PostState {
  final String message;

  const ErrorPostState({required this.message});

  @override
  List<Object> get props => [message];
}
