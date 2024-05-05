import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ebn_balady/core/errors/failures.dart';
import 'package:ebn_balady/features/posts/data/repositories/comments_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants.dart';
import '../../../data/models/comment/comment_model.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsRepository commentsRepository;

  CommentsBloc({required this.commentsRepository}) : super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) async {
      if (event is GetCommentsEvent) {
        await getComments(event.postId, event.pageNumber);
      } else if (event is RefreshCommentsEvent) {
        await getComments(event.postId, event.pageNumber);
      } else {
        final Either<Failure, dynamic> failureOrMessage;
        final Either<Failure, dynamic> failureOrComment;
        if (event is AddCommentEvent) {
          emit(LoadingCommentsAddState());
          failureOrComment =
              await commentsRepository.addComment(event.body, event.postId);
          emit(failureOrComment.fold(
              (failure) => ErrorAddDeleteUpdateState(
                  message: _mapFailureToMessage(failure)),
              (comment) => CommentAddState(
                    message: addSuccessMessage,
                    comment: comment,
                  )));
        } else if (event is UpdateCommentEvent) {
          emit(LoadingCommentsUpdateState());
          failureOrMessage = await commentsRepository.updateComment(
              event.newComment, event.postId);
          emit(failureOrMessage.fold(
              (failure) => ErrorAddDeleteUpdateState(
                  message: _mapFailureToMessage(failure)),
              (_) => MessageCommentUpdateState(
                  message: updateSuccessMessage,
                  newBody: event.newComment.body!,
                  index: event.index)));
        } else if (event is DeleteCommentEvent) {
          emit(LoadingCommentsDeleteState());
          failureOrMessage = await commentsRepository.deleteComment(
              event.commentId, event.postId);
          emit(failureOrMessage.fold(
              (failure) => ErrorAddDeleteUpdateState(
                  message: _mapFailureToMessage(failure)),
              (_) => MessageCommentDeleteState(
                  message: deleteSuccessMessage, index: event.index)));
        }
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
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

  CommentsState _mapFailureOrCommentsToState(
      Either<Failure, dynamic> failureOrComments) {
    return failureOrComments.fold(
        (failure) => ErrorCommentsState(message: _mapFailureToMessage(failure)),
        (comments) => LoadedCommentsState(comments: comments));
  }

  Future<void> getComments(int postId, int pageNumber) async {
    emit(LoadingCommentsState());
    final failureOrComments =
        await commentsRepository.getComments(postId, pageNumber);
    emit(_mapFailureOrCommentsToState(failureOrComments));
  }
}
