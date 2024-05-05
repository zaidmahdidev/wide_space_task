part of 'posts_bloc.dart';

@immutable
abstract class PostsState {
  const PostsState();

  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class LoadingPostsState extends PostsState {}

class LoadedPostsState extends PostsState {
  final List<PostModel> posts;

  const LoadedPostsState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class ErrorPostsState extends PostsState {
  final String message;

  const ErrorPostsState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingAddDeleteUpdateState extends PostsState {}

class ErrorAddDeleteUpdateState extends PostsState {
  final String message;

  const ErrorAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdateState extends PostsState {
  final String message;

  const MessageAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}
