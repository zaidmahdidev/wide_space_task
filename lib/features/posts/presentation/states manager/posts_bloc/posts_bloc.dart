import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ebn_balady/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants.dart';
import '../../../data/models/post/Post.dart';
import '../../../data/repositories/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;

  PostsBloc({
    required this.postsRepository,
  }) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await postsRepository.getPosts(event.pageNumber);
        emit(_mapFailureOrPostsToState(failureOrPosts));
      } else {
        emit(LoadingAddDeleteUpdateState());
        final Either<Failure, dynamic> failureOrMessage;
        if (event is AddPostEvent) {
          failureOrMessage = await postsRepository.addPost(event.post);
          emit(
              _eitherDoneMessageOrFailure(failureOrMessage, addSuccessMessage));
        } else if (event is UpdatePostEvent) {
          failureOrMessage = await postsRepository.updatePost(event.post);
          emit(_eitherDoneMessageOrFailure(
              failureOrMessage, updateSuccessMessage));
        } else if (event is DeletePostEvent) {
          failureOrMessage = await postsRepository.deletePost(event.postId);
          emit(_eitherDoneMessageOrFailure(
              failureOrMessage, deleteSuccessMessage));
        }
      }
    });
  }

  _eitherDoneMessageOrFailure(
      Either<Failure, dynamic> failureOrMessage, String message) {
    return failureOrMessage.fold(
        (failure) =>
            ErrorAddDeleteUpdateState(message: mapFailureToMessage(failure)),
        (_) => MessageAddDeleteUpdateState(message: message));
  }

  PostsState _mapFailureOrPostsToState(
      Either<Failure, dynamic> failureOrPosts) {
    return failureOrPosts.fold(
        (failure) => ErrorPostsState(message: mapFailureToMessage(failure)),
        (posts) => LoadedPostsState(posts: posts));
  }
}
