import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/errors/failures.dart';
import '../../../data/models/comment/comment_model.dart';
import '../../../data/repositories/comments_repository.dart';

part 'comment_like_event.dart';
part 'comment_like_state.dart';

class CommentLikeBloc extends Bloc<CommentLikeEvent, CommentLikeState> {
  final CommentsRepository commentsRepository;

  CommentLikeBloc({required this.commentsRepository}) : super(LikeInitial()) {
    on<CommentLikeEvent>((event, emit) async {
      if (event is AddLikeEvent) {
        emit(LikeLoading());
        final failureOrComment = await commentsRepository.addCommentLike(
            event.commentId, event.postId);
        emit(_mapLikeFailureOrCommentToState(failureOrComment, true));
      } else if (event is RemoveLikeEvent) {
        emit(LikeLoading());
        final failureOrComment = await commentsRepository.removeCommentLike(
            event.commentId, event.postId);
        emit(_mapLikeFailureOrCommentToState(failureOrComment, false));
      } else if (event is AddDislikeEvent) {
        emit(DislikeLoading());
        final failureOrComment = await commentsRepository.addCommentDislike(
            event.commentId, event.postId);
        emit(_mapDislikeFailureOrCommentToState(failureOrComment, true));
      } else if (event is RemoveDislikeEvent) {
        emit(DislikeLoading());
        final failureOrComment = await commentsRepository.removeCommentDislike(
            event.commentId, event.postId);
        emit(_mapDislikeFailureOrCommentToState(failureOrComment, false));
      }
    });
  }

  String _mapLikeFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case EmptyCacheFailure:
        return emptyCacheFailureMessage;
      case OfflineFailure:
        return offlineFailureMessage;
      default:
        return "Unexpected Error, Please try again later.";
    }
  }

  CommentLikeState _mapLikeFailureOrCommentToState(
      Either<Failure, dynamic> failureOrComment, bool likeAdded) {
    return failureOrComment.fold(
        (failure) => ErrorLikeState(message: _mapLikeFailureToMessage(failure)),
        (comment) => likeAdded
            ? LikeAdded(comment: comment)
            : LikeRemoved(comment: comment));
  }

  CommentLikeState _mapDislikeFailureOrCommentToState(
      Either<Failure, dynamic> failureOrComment, bool likeAdded) {
    return failureOrComment.fold(
        (failure) => ErrorLikeState(message: _mapLikeFailureToMessage(failure)),
        (comment) => likeAdded
            ? DislikeAdded(comment: comment)
            : DislikeRemoved(comment: comment));
  }
}
