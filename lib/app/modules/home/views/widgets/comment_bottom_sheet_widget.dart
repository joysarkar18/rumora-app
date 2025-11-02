import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/data/models/comment_model.dart';
import 'package:campus_crush_app/app/data/models/post_model.dart';
import 'package:campus_crush_app/app/modules/home/controllers/comment_controller.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';

class CommentsBottomSheet extends StatelessWidget {
  final PostModel post;
  final String postDocId;
  final Function(int) onCommentCountChange;

  const CommentsBottomSheet({
    super.key,
    required this.post,
    required this.postDocId,
    required this.onCommentCountChange,
  });

  @override
  Widget build(BuildContext context) {
    final CommentController commentController = Get.put(
      CommentController(onCommentCountChange: onCommentCountChange),
      tag: postDocId,
    );
    final UserController userController = Get.find<UserController>();

    // Initialize with post data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentController.initializePost(post, postDocId);
    });

    return SafeArea(
      bottom: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.primary.withAlpha(20)),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Comments List
            Expanded(
              child: Obx(() {
                if (commentController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (commentController.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.iconsComment,
                          color: AppColors.grayDark,
                          width: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    final isOwnComment =
                        comment.userId == userController.user.value?.userId;

                    return Column(
                      children: [
                        _CommentItem(
                          comment: comment,
                          isOwnComment: isOwnComment,
                          commentController: commentController,
                          parentIndex: index,
                          onDelete: () {
                            _showDeleteDialog(
                              context,
                              commentController,
                              comment,
                              index,
                            );
                          },
                          onLike: () {
                            commentController.toggleCommentLike(
                              comment,
                              false,
                              null,
                            );
                          },
                          onReply: () {
                            commentController.setReplyTo(
                              comment.id,
                              comment.username,
                            );
                          },
                        ),

                        // Replies Section
                        Obx(() {
                          final hasReplies = comment.repliesCount > 0;
                          final showRepliesList =
                              commentController.showReplies[comment.id] ??
                              false;
                          final replyList =
                              commentController.replies[comment.id] ?? [];
                          final isLoadingReplies =
                              commentController.loadingReplies[comment.id] ??
                              false;

                          if (!hasReplies && replyList.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // View Replies Button
                                if (hasReplies && !showRepliesList)
                                  InkWell(
                                    onTap: () => commentController
                                        .toggleReplies(comment.id),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.subdirectory_arrow_right,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'View ${comment.repliesCount} ${comment.repliesCount == 1 ? 'reply' : 'replies'}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Loading Replies
                                if (isLoadingReplies)
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Replies List
                                if (showRepliesList && !isLoadingReplies)
                                  ...replyList.map((reply) {
                                    final isOwnReply =
                                        reply.userId ==
                                        userController.user.value?.userId;
                                    return _CommentItem(
                                      comment: reply,
                                      isOwnComment: isOwnReply,
                                      commentController: commentController,
                                      isReply: true,
                                      parentIndex: index,
                                      onDelete: () {
                                        _showDeleteDialog(
                                          context,
                                          commentController,
                                          reply,
                                          index,
                                        );
                                      },
                                      onLike: () {
                                        commentController.toggleCommentLike(
                                          reply,
                                          true,
                                          index,
                                        );
                                      },
                                      onReply: () {
                                        commentController.setReplyTo(
                                          comment.id,
                                          reply.username,
                                        );
                                      },
                                    );
                                  }).toList(),

                                // Hide Replies Button
                                if (showRepliesList && !isLoadingReplies)
                                  InkWell(
                                    onTap: () => commentController
                                        .toggleReplies(comment.id),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.subdirectory_arrow_right,
                                            size: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Hide replies',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              }),
            ),

            // Reply To Banner
            Obx(() {
              if (commentController.replyingToUsername.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(40),
                  border: Border(
                    top: BorderSide(color: AppColors.primary.withAlpha(40)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Replying to ${commentController.replyingToUsername.value}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        commentController.cancelReply();
                      },
                    ),
                  ],
                ),
              );
            }),

            // Comment Input - UI IMPROVED VERSION
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: commentController.commentTextController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: commentController.isSubmitting.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.send, size: 20),
                          color: Colors.white,
                          onPressed: commentController.isSubmitting.value
                              ? null
                              : () {
                                  commentController.addComment();
                                },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    CommentController controller,
    CommentModel comment,
    int? parentIndex,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Comment'),
        content: Text(
          comment.repliesCount > 0
              ? 'This will also delete ${comment.repliesCount} ${comment.repliesCount == 1 ? 'reply' : 'replies'}. Are you sure?'
              : 'Are you sure you want to delete this comment?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteComment(comment, parentIndex);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isOwnComment;
  final CommentController commentController;
  final VoidCallback onDelete;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final bool isReply;
  final int? parentIndex;

  const _CommentItem({
    Key? key,
    required this.comment,
    required this.isOwnComment,
    required this.commentController,
    required this.onDelete,
    required this.onLike,
    required this.onReply,
    this.isReply = false,
    this.parentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isLiked = comment.likedBy.contains(
      userController.user.value?.userId ?? '',
    );

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 40 : 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          AvatarPlus(comment.username, height: 40, width: 40),
          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isReply ? 13 : 14,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: onLike,
                      child: SizedBox(
                        width: 40,
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: isReply ? 16 : 18,
                              color: isLiked
                                  ? Colors.red
                                  : Colors.grey.shade600,
                            ),
                            if (comment.likes > 0) ...[
                              const SizedBox(width: 4),
                              Text(
                                comment.likes.toString(),
                                style: TextStyle(
                                  fontSize: isReply ? 11 : 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  GetTimeAgo.parse(comment.createdAt),
                  style: TextStyle(
                    fontSize: isReply ? 11 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  comment.content,
                  style: TextStyle(fontSize: isReply ? 13 : 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: isReply ? 12 : 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
