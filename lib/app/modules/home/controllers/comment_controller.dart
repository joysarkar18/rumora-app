import 'package:campus_crush_app/app/data/models/comment_model.dart';
import 'package:campus_crush_app/app/data/models/post_model.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController commentTextController = TextEditingController();

  RxList<CommentModel> comments = <CommentModel>[].obs;
  RxMap<String, List<CommentModel>> replies =
      <String, List<CommentModel>>{}.obs;
  RxMap<String, bool> showReplies = <String, bool>{}.obs;
  RxMap<String, bool> loadingReplies = <String, bool>{}.obs;

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool hasLoadedComments = false.obs;
  RxString postDocId = ''.obs;
  RxString replyingToCommentId = ''.obs;
  RxString replyingToUsername = ''.obs;

  late PostModel currentPost;
  final Function(int)? onCommentCountChange;

  CommentController({this.onCommentCountChange});

  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }

  void initializePost(PostModel post, String docId) {
    // If already initialized for this post, don't reinitialize
    if (postDocId.value == docId && hasLoadedComments.value) {
      return;
    }

    currentPost = post;

    // Only reset if it's a different post
    if (postDocId.value != docId) {
      postDocId.value = docId;
      hasLoadedComments.value = false;
      comments.clear();
      replies.clear();
      showReplies.clear();
      loadingReplies.clear();
    }

    loadComments();
  }

  void setReplyTo(String commentId, String username) {
    replyingToCommentId.value = commentId;
    replyingToUsername.value = username;
    commentTextController.text = '@$username ';
  }

  void cancelReply() {
    replyingToCommentId.value = '';
    replyingToUsername.value = '';
    commentTextController.clear();
  }

  Future<void> loadComments() async {
    // Prevent loading if already loading or already loaded for this post
    if (isLoading.value) return;

    // If comments are already loaded for this post, don't reload
    if (hasLoadedComments.value && comments.isNotEmpty) return;

    try {
      isLoading.value = true;

      // Load only parent comments (no parentCommentId)
      final snapshot = await _firestore
          .collection('posts')
          .doc(postDocId.value)
          .collection('comments')
          .where('parentCommentId', isEqualTo: '')
          .orderBy('createdAt', descending: true)
          .get();

      comments.value = snapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc))
          .toList();

      hasLoadedComments.value = true;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasLoadedComments.value = false;
      Get.snackbar(
        'Error',
        'Failed to load comments',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> loadReplies(String commentId) async {
    if (loadingReplies[commentId] == true) return;

    try {
      loadingReplies[commentId] = true;

      final snapshot = await _firestore
          .collection('posts')
          .doc(postDocId.value)
          .collection('comments')
          .where('parentCommentId', isEqualTo: commentId)
          .orderBy('createdAt', descending: false)
          .get();

      replies[commentId] = snapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc))
          .toList();

      showReplies[commentId] = true;
      loadingReplies[commentId] = false;
    } catch (e) {
      loadingReplies[commentId] = false;
      Get.snackbar(
        'Error',
        'Failed to load replies',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  void toggleReplies(String commentId) {
    if (showReplies[commentId] == true) {
      showReplies[commentId] = false;
    } else {
      if (replies[commentId] == null) {
        loadReplies(commentId);
      } else {
        showReplies[commentId] = true;
      }
    }
  }

  Future<void> addComment() async {
    if (commentTextController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Comment cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return;
    }

    if (_userController.user.value == null) {
      Get.snackbar(
        'Error',
        'User not found!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final user = _userController.user.value!;
      final now = DateTime.now();
      final isReply = replyingToCommentId.value.isNotEmpty;

      final comment = CommentModel(
        postId: postDocId.value,
        userId: user.userId,
        username: user.username,
        gender: user.gender,
        phoneNo: user.phoneNo,
        content: commentTextController.text.trim(),
        createdAt: now,
        updatedAt: now,
        parentCommentId: replyingToCommentId.value,
      );

      final batch = _firestore.batch();

      // Add comment to subcollection
      final commentRef = _firestore
          .collection('posts')
          .doc(postDocId.value)
          .collection('comments')
          .doc();

      batch.set(commentRef, comment.toJson());

      if (isReply) {
        // If it's a reply, increment reply count on parent comment
        final parentCommentRef = _firestore
            .collection('posts')
            .doc(postDocId.value)
            .collection('comments')
            .doc(replyingToCommentId.value);

        batch.update(parentCommentRef, {
          'repliesCount': FieldValue.increment(1),
        });

        // Also increment the total comment count on post
        final postRef = _firestore.collection('posts').doc(postDocId.value);
        batch.update(postRef, {'comments': FieldValue.increment(1)});
      } else {
        // If it's a parent comment, increment comment count on post
        final postRef = _firestore.collection('posts').doc(postDocId.value);
        batch.update(postRef, {'comments': FieldValue.increment(1)});
      }

      await batch.commit();

      if (isReply) {
        // Add reply to local list
        if (replies[replyingToCommentId.value] == null) {
          replies[replyingToCommentId.value] = [];
        }
        replies[replyingToCommentId.value]!.add(
          comment.copyWith(id: commentRef.id),
        );

        // Update parent comment reply count
        final parentIndex = comments.indexWhere(
          (c) => c.id == replyingToCommentId.value,
        );
        if (parentIndex != -1) {
          comments[parentIndex] = comments[parentIndex].copyWith(
            repliesCount: comments[parentIndex].repliesCount + 1,
          );
        }

        // Show replies if hidden
        showReplies[replyingToCommentId.value] = true;
      } else {
        // Add parent comment to local list
        comments.insert(0, comment.copyWith(id: commentRef.id));
      }

      // Update comment count in UI
      if (onCommentCountChange != null) {
        onCommentCountChange!(1);
      }

      // Clear input and reply state
      commentTextController.clear();
      cancelReply();

      isSubmitting.value = false;

      Get.snackbar(
        'Success',
        isReply ? 'Reply added successfully' : 'Comment added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      isSubmitting.value = false;
      Get.snackbar(
        'Error',
        'Failed to add comment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> deleteComment(CommentModel comment, int? parentIndex) async {
    try {
      final batch = _firestore.batch();

      final isReply = comment.parentCommentId.isNotEmpty;

      // Delete comment
      final commentRef = _firestore
          .collection('posts')
          .doc(postDocId.value)
          .collection('comments')
          .doc(comment.id);

      batch.delete(commentRef);

      // Calculate total comments to delete (comment + its replies)
      int totalToDelete = 1;

      if (!isReply && comment.repliesCount > 0) {
        // If deleting a parent comment, also delete all its replies
        final repliesSnapshot = await _firestore
            .collection('posts')
            .doc(postDocId.value)
            .collection('comments')
            .where('parentCommentId', isEqualTo: comment.id)
            .get();

        for (var replyDoc in repliesSnapshot.docs) {
          batch.delete(replyDoc.reference);
        }

        totalToDelete += repliesSnapshot.docs.length;
      }

      if (isReply) {
        // Decrement parent comment reply count
        final parentCommentRef = _firestore
            .collection('posts')
            .doc(postDocId.value)
            .collection('comments')
            .doc(comment.parentCommentId);

        batch.update(parentCommentRef, {
          'repliesCount': FieldValue.increment(-1),
        });
      }

      // Decrement post comment count
      final postRef = _firestore.collection('posts').doc(postDocId.value);
      batch.update(postRef, {'comments': FieldValue.increment(-totalToDelete)});

      await batch.commit();

      // Update local lists
      if (isReply) {
        replies[comment.parentCommentId]?.removeWhere(
          (c) => c.id == comment.id,
        );

        // Update parent comment reply count
        if (parentIndex != null) {
          comments[parentIndex] = comments[parentIndex].copyWith(
            repliesCount: comments[parentIndex].repliesCount - 1,
          );
        }
      } else {
        comments.removeWhere((c) => c.id == comment.id);
        replies.remove(comment.id);
        showReplies.remove(comment.id);
      }

      // Update comment count in UI
      if (onCommentCountChange != null) {
        onCommentCountChange!(-totalToDelete);
      }

      Get.snackbar(
        'Success',
        'Comment deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete comment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  Future<void> toggleCommentLike(
    CommentModel comment,
    bool isReply,
    int? parentIndex,
  ) async {
    if (_userController.user.value == null) return;

    try {
      final userId = _userController.user.value!.userId;
      final isLiked = comment.likedBy.contains(userId);

      // Optimistic update
      final updatedLikedBy = List<String>.from(comment.likedBy);

      if (isLiked) {
        updatedLikedBy.remove(userId);
      } else {
        updatedLikedBy.add(userId);
      }

      final updatedComment = comment.copyWith(
        likedBy: updatedLikedBy,
        likes: isLiked ? comment.likes - 1 : comment.likes + 1,
      );

      // Update local list
      if (isReply && comment.parentCommentId.isNotEmpty) {
        final replyList = replies[comment.parentCommentId];
        if (replyList != null) {
          final replyIndex = replyList.indexWhere((c) => c.id == comment.id);
          if (replyIndex != -1) {
            replyList[replyIndex] = updatedComment;
            replies[comment.parentCommentId] = List.from(replyList);
          }
        }
      } else {
        final commentIndex = comments.indexWhere((c) => c.id == comment.id);
        if (commentIndex != -1) {
          comments[commentIndex] = updatedComment;
        }
      }

      // Update Firestore
      final commentRef = _firestore
          .collection('posts')
          .doc(postDocId.value)
          .collection('comments')
          .doc(comment.id);

      if (isLiked) {
        await commentRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likes': FieldValue.increment(-1),
        });
      } else {
        await commentRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likes': FieldValue.increment(1),
        });
      }
    } catch (e) {
      await loadComments(); // Revert on error
    }
  }
}
