import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/common/widgets/common_image_view.dart';
import 'package:campus_crush_app/app/data/models/post_model.dart';
import 'package:campus_crush_app/app/modules/home/controllers/home_controller.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/comment_bottom_sheet_widget.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:math' as math;
import 'dart:async';

class PostCard extends StatefulWidget {
  final int postIndex;

  const PostCard({super.key, required this.postIndex});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;

  late AnimationController _likeAnimationController;
  late AnimationController _likeExplosionController;
  late AnimationController _poopThrowController;
  late AnimationController _doubleTapHeartController;

  late Animation<double> _likeScaleAnimation;
  late Animation<double> _likeRotationAnimation;
  late Animation<double> _doubleTapHeartScale;
  late Animation<double> _doubleTapHeartOpacity;

  // Poop throw animations
  late Animation<Offset> _poopPositionAnimation;
  late Animation<double> _poopRotationAnimation;
  late Animation<double> _poopScaleAnimation;
  late Animation<double> _poopOpacityAnimation;
  late Animation<double> _poopTrailOpacity;

  final HomeController _homeController = Get.find<HomeController>();
  final UserController _userController = Get.find<UserController>();

  final List<PoopParticle> _poopParticles = [];
  final List<HeartParticle> _heartParticles = [];
  bool _showPoopAnimation = false;
  bool _showHeartAnimation = false;
  bool _showDoubleTapHeart = false;

  // Screen shake effect
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Double tap detection
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Like button animation controller
    _likeAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _likeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_likeAnimationController);

    _likeRotationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0.2), weight: 50),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: -0.2),
        weight: 25,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: -0.2, end: 0), weight: 25),
    ]).animate(_likeAnimationController);

    // Heart explosion controller
    _likeExplosionController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _likeExplosionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showHeartAnimation = false;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _heartParticles.clear();
            });
          }
        });
      }
    });

    // Double tap heart animation
    _doubleTapHeartController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _doubleTapHeartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_doubleTapHeartController);

    _doubleTapHeartOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 40),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_doubleTapHeartController);

    _doubleTapHeartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showDoubleTapHeart = false;
        });
      }
    });

    // Poop throw animation controller
    _poopThrowController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Enhanced curved trajectory with more realistic physics
    _poopPositionAnimation = TweenSequence<Offset>([
      // Launch phase
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(0, 1.8),
          end: Offset(-0.1, 0.2),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      // Arc peak
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(-0.1, 0.2),
          end: Offset(0, -0.3),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      // Falling phase with gravity
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(0, -0.3),
          end: Offset(0.05, -0.6),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_poopThrowController);

    // Faster rotation for more impact
    _poopRotationAnimation =
        Tween<double>(
          begin: 0,
          end: math.pi * 6, // 6 full rotations
        ).animate(
          CurvedAnimation(parent: _poopThrowController, curve: Curves.linear),
        );

    // More dramatic scale
    _poopScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.4,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 35,
      ),
    ]).animate(_poopThrowController);

    _poopOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 75),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_poopThrowController);

    // Trail opacity for motion blur effect
    _poopTrailOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _poopThrowController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _poopThrowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerScreenShake();
        setState(() {
          _showPoopAnimation = false;
          _createEnhancedPoopSplat();
        });

        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _poopParticles.clear();
            });
          }
        });
      }
    });

    // Screen shake controller
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: -5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -5, end: 3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 3, end: -3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -3, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _likeAnimationController.dispose();
    _likeExplosionController.dispose();
    _poopThrowController.dispose();
    _shakeController.dispose();
    _doubleTapHeartController.dispose();
    _tapTimer?.cancel();
    super.dispose();
  }

  void _triggerScreenShake() {
    _shakeController.forward(from: 0);
  }

  void _createEnhancedPoopSplat() {
    final random = math.Random();
    // More particles for bigger impact
    for (int i = 0; i < 15; i++) {
      _poopParticles.add(
        PoopParticle(
          angle: (i * math.pi * 2 / 15) + random.nextDouble() * 0.4,
          distance: 30 + random.nextDouble() * 60,
          size: 3 + random.nextDouble() * 10,
          duration: 500 + random.nextInt(400),
          velocity: 0.5 + random.nextDouble() * 1.5,
          isReverse: false,
        ),
      );
    }

    // Add some bigger chunks
    for (int i = 0; i < 5; i++) {
      _poopParticles.add(
        PoopParticle(
          angle: random.nextDouble() * math.pi * 2,
          distance: 20 + random.nextDouble() * 40,
          size: 8 + random.nextDouble() * 8,
          duration: 600 + random.nextInt(300),
          velocity: 0.3 + random.nextDouble() * 0.7,
          isReverse: false,
        ),
      );
    }
  }

  void _createPoopVacuum() {
    final random = math.Random();
    // Create particles that get sucked back
    for (int i = 0; i < 12; i++) {
      _poopParticles.add(
        PoopParticle(
          angle: (i * math.pi * 2 / 12) + random.nextDouble() * 0.3,
          distance: 40 + random.nextDouble() * 50,
          size: 4 + random.nextDouble() * 8,
          duration: 500 + random.nextInt(250),
          velocity: 1.0,
          isReverse: true,
        ),
      );
    }
  }

  void _createHeartExplosion() {
    final random = math.Random();
    // Create multiple hearts with different sizes and trajectories
    for (int i = 0; i < 12; i++) {
      _heartParticles.add(
        HeartParticle(
          angle: (i * math.pi * 2 / 12) + random.nextDouble() * 0.3,
          distance: 40 + random.nextDouble() * 80,
          size: 12 + random.nextDouble() * 20,
          duration: 800 + random.nextInt(400),
          rotation: random.nextDouble() * math.pi * 2,
          floatHeight: 20 + random.nextDouble() * 40,
          isReverse: false,
        ),
      );
    }
  }

  void _createHeartImplosion() {
    final random = math.Random();
    // Create hearts that get sucked inward
    for (int i = 0; i < 10; i++) {
      _heartParticles.add(
        HeartParticle(
          angle: (i * math.pi * 2 / 10) + random.nextDouble() * 0.4,
          distance: 60 + random.nextDouble() * 60,
          size: 10 + random.nextDouble() * 16,
          duration: 600 + random.nextInt(300),
          rotation: random.nextDouble() * math.pi * 2,
          floatHeight: 0,
          isReverse: true,
        ),
      );
    }
  }

  void _onLikeTap() {
    final post = _homeController.posts[widget.postIndex];
    final userId = _userController.user.value?.userId ?? '';
    final isLiked = post.likedBy.contains(userId);

    _homeController.toggleLike(widget.postIndex);

    // Trigger button animation
    _likeAnimationController.forward(from: 0);

    if (!isLiked) {
      // Giving like - explosion animation
      setState(() {
        _showHeartAnimation = true;
        _createHeartExplosion();
      });
      _likeExplosionController.forward(from: 0);
    } else {
      // Taking back like - implosion animation
      setState(() {
        _showHeartAnimation = true;
        _createHeartImplosion();
      });
      _likeExplosionController.forward(from: 0);
    }
  }

  void _handleDoubleTap() {
    final post = _homeController.posts[widget.postIndex];
    final userId = _userController.user.value?.userId ?? '';
    final isLiked = post.likedBy.contains(userId);

    // Only trigger if not already liked
    if (!isLiked) {
      _homeController.toggleLike(widget.postIndex);

      // Show big heart animation
      setState(() {
        _showDoubleTapHeart = true;
        _showHeartAnimation = true;
        _createHeartExplosion();
      });

      _doubleTapHeartController.forward(from: 0);
      _likeExplosionController.forward(from: 0);
    }
  }

  void _onContentTap() {
    _tapCount++;

    if (_tapCount == 1) {
      // Start timer for double tap detection
      _tapTimer?.cancel();
      _tapTimer = Timer(Duration(milliseconds: 300), () {
        // Single tap - do nothing for now
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      // Double tap detected
      _tapTimer?.cancel();
      _tapCount = 0;
      _handleDoubleTap();
    }
  }

  void _onPoopTap() {
    final post = _homeController.posts[widget.postIndex];
    final userId = _userController.user.value?.userId ?? '';
    final isPooped = post.poopBy.contains(userId);

    _homeController.togglePoop(widget.postIndex);

    if (!isPooped) {
      // Giving poop - throw animation
      setState(() {
        _showPoopAnimation = true;
      });
      _poopThrowController.forward(from: 0);
    } else {
      // Taking back poop - vacuum animation (no throw, just particles)
      setState(() {
        _createPoopVacuum();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = _homeController.posts[widget.postIndex];
      final userId = _userController.user.value?.userId ?? '';
      final isLiked = post.likedBy.contains(userId);
      final isPooped = post.poopBy.contains(userId);

      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              // Header with avatar and user info
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AvatarPlus(
                                    post.username,
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          post.username,
                                          style: AppTextStyles.style14w500(
                                            color: AppColors.grayBlue,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          post.college.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.style12w400(
                                            color: AppColors.grayBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    GetTimeAgo.parse(post.createdAt),
                                    style: AppTextStyles.style12w600(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),

                              // Post content with images carousel - Double tap to like
                              GestureDetector(
                                onTap: _onContentTap,
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightPink.withValues(
                                      alpha: 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text content
                                          Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                              post.postContent,
                                              style: AppTextStyles.style14w500(
                                                color: AppColors.grayBlue,
                                              ),
                                            ),
                                          ),
                                          // Images carousel
                                          if (post.imageUrls.isNotEmpty)
                                            _buildImagesCarousel(
                                              post.imageUrls,
                                            ),
                                        ],
                                      ),
                                      // Double tap heart overlay
                                      if (_showDoubleTapHeart)
                                        Positioned.fill(
                                          child: Center(
                                            child: AnimatedBuilder(
                                              animation:
                                                  _doubleTapHeartController,
                                              builder: (context, child) {
                                                return Transform.scale(
                                                  scale: _doubleTapHeartScale
                                                      .value,
                                                  child: Opacity(
                                                    opacity:
                                                        _doubleTapHeartOpacity
                                                            .value,
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.red
                                                                .withValues(
                                                                  alpha: 0.6,
                                                                ),
                                                            blurRadius: 30,
                                                            spreadRadius: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.favorite,
                                                        size: 100,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Engagement stats with interactive buttons
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(width: 4),
                              // Like button with enhanced animation
                              GestureDetector(
                                onTap: _onLikeTap,
                                child: AnimatedBuilder(
                                  animation: _likeAnimationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _likeScaleAnimation.value,
                                      child: Transform.rotate(
                                        angle: _likeRotationAnimation.value,
                                        child: TweenAnimationBuilder<Color?>(
                                          duration: Duration(milliseconds: 300),
                                          tween: ColorTween(
                                            begin: isLiked
                                                ? Colors.red
                                                : AppColors.primary,
                                            end: isLiked
                                                ? Colors.red
                                                : AppColors.primary,
                                          ),
                                          builder: (context, color, child) {
                                            return Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                isLiked
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                          .favorite_border_rounded,
                                                color: color,
                                                size: 24,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 4),
                              TweenAnimationBuilder<int>(
                                duration: Duration(milliseconds: 300),
                                tween: IntTween(
                                  begin: post.likes,
                                  end: post.likes,
                                ),
                                builder: (context, value, child) {
                                  return Text(
                                    "$value",
                                    style: AppTextStyles.style15w700(
                                      color: AppColors.primary,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 16),
                              InkWell(
                                onTap: () async {
                                  final homeController =
                                      Get.find<HomeController>();
                                  final docId = post.postId;
                                  if (docId.isNotEmpty) {
                                    Get.bottomSheet(
                                      CommentsBottomSheet(
                                        post: post,
                                        postDocId: docId,
                                        onCommentCountChange: (change) {
                                          final postIndex = homeController.posts
                                              .indexWhere(
                                                (p) =>
                                                    p.userId == post.userId &&
                                                    p.createdAt ==
                                                        post.createdAt,
                                              );
                                          if (postIndex != -1) {
                                            homeController
                                                .updatePostCommentCount(
                                                  postIndex,
                                                  change,
                                                );
                                          }
                                        },
                                      ),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      ignoreSafeArea: false,
                                    );
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Could not open comments',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    // Comment icon
                                    SvgPicture.asset(
                                      Assets.iconsComment,
                                      height: 21,
                                    ),

                                    SizedBox(width: 4),
                                    Text(
                                      "${post.comments}",
                                      style: AppTextStyles.style15w700(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 16),
                              // Poop button
                              GestureDetector(
                                onTap: _onPoopTap,
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 300),
                                  tween: Tween<double>(
                                    begin: isPooped ? 1.0 : 0.4,
                                    end: isPooped ? 1.0 : 0.4,
                                  ),
                                  builder: (context, opacity, child) {
                                    return Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        isPooped
                                            ? Assets.iconsPoopFilled
                                            : Assets.iconsPoop,
                                        height: 22,
                                        color: AppColors.orangePrimary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 4),
                              TweenAnimationBuilder<int>(
                                duration: Duration(milliseconds: 300),
                                tween: IntTween(
                                  begin: post.poops,
                                  end: post.poops,
                                ),
                                builder: (context, value, child) {
                                  return Text(
                                    "$value",
                                    style: AppTextStyles.style15w700(
                                      color: AppColors.orangePrimary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Flying poop animation with motion trail
                  if (_showPoopAnimation)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _poopThrowController,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Motion trail (3 trailing poops)
                              for (int i = 1; i <= 3; i++)
                                Opacity(
                                  opacity:
                                      _poopTrailOpacity.value * (1 - i * 0.25),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: FractionalTranslation(
                                      translation: Offset(
                                        _poopPositionAnimation.value.dx,
                                        _poopPositionAnimation.value.dy +
                                            (i * 0.08),
                                      ),
                                      child: Transform.rotate(
                                        angle:
                                            _poopRotationAnimation.value -
                                            (i * 0.3),
                                        child: Transform.scale(
                                          scale:
                                              _poopScaleAnimation.value *
                                              (1 - i * 0.15),
                                          child: SvgPicture.asset(
                                            Assets.iconsPoopFilled,
                                            height: 40,
                                            color: AppColors.orangePrimary
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Main poop
                              Align(
                                alignment: Alignment.center,
                                child: FractionalTranslation(
                                  translation: _poopPositionAnimation.value,
                                  child: Transform.rotate(
                                    angle: _poopRotationAnimation.value,
                                    child: Transform.scale(
                                      scale: _poopScaleAnimation.value,
                                      child: Opacity(
                                        opacity: _poopOpacityAnimation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.orangePrimary
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: SvgPicture.asset(
                                            Assets.iconsPoopFilled,
                                            height: 50,
                                            color: AppColors.orangePrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  // Poop splat particles
                  ..._poopParticles.map((particle) {
                    return Positioned(
                      top: 60,
                      left: MediaQuery.of(context).size.width / 2 - 16,
                      child: PoopSplatParticleWidget(particle: particle),
                    );
                  }).toList(),

                  // Heart explosion particles - FIXED POSITIONING
                  if (_showHeartAnimation)
                    ..._heartParticles.map((particle) {
                      return Positioned.fill(
                        child: Center(
                          child: HeartParticleWidget(particle: particle),
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildImagesCarousel(List<String> urls) {
    if (urls.isEmpty) return SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return CommonImageView(
                  url: urls[index],
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                );
              },
            ),
            if (urls.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    urls.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentImageIndex == index ? 20 : 6,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? AppColors.primary.withAlpha(140)
                              : Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Enhanced poop particle model
class PoopParticle {
  final double angle;
  final double distance;
  final double size;
  final int duration;
  final double velocity;
  final bool isReverse;

  PoopParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.duration,
    required this.velocity,
    required this.isReverse,
  });
}

// Poop splat particle widget with enhanced physics
class PoopSplatParticleWidget extends StatefulWidget {
  final PoopParticle particle;

  const PoopSplatParticleWidget({super.key, required this.particle});

  @override
  State<PoopSplatParticleWidget> createState() =>
      _PoopSplatParticleWidgetState();
}

class _PoopSplatParticleWidgetState extends State<PoopSplatParticleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.particle.duration),
      vsync: this,
    );

    if (widget.particle.isReverse) {
      // Vacuum animation - particles move inward
      _offsetAnimation = Tween<double>(begin: widget.particle.distance, end: 0)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
          );

      _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.6, 1.0, curve: Curves.easeIn),
        ),
      );

      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
      );
    } else {
      // Explosion animation - particles move outward
      _offsetAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: widget.particle.distance,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 70,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: widget.particle.distance,
            end: widget.particle.distance * 1.1,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 30,
        ),
      ]).animate(_controller);

      _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.4, 1.0, curve: Curves.easeIn),
        ),
      );

      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 1.3,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.3,
            end: 0.5,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 70,
        ),
      ]).animate(_controller);
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = math.cos(widget.particle.angle) * _offsetAnimation.value;
        final dy = math.sin(widget.particle.angle) * _offsetAnimation.value;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: widget.particle.size,
                height: widget.particle.size,
                decoration: BoxDecoration(
                  color: AppColors.orangePrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orangePrimary.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Heart particle model
class HeartParticle {
  final double angle;
  final double distance;
  final double size;
  final int duration;
  final double rotation;
  final double floatHeight;
  final bool isReverse;

  HeartParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.duration,
    required this.rotation,
    required this.floatHeight,
    required this.isReverse,
  });
}

// Heart particle widget with floating animation
class HeartParticleWidget extends StatefulWidget {
  final HeartParticle particle;

  const HeartParticleWidget({super.key, required this.particle});

  @override
  State<HeartParticleWidget> createState() => _HeartParticleWidgetState();
}

class _HeartParticleWidgetState extends State<HeartParticleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.particle.duration),
      vsync: this,
    );

    if (widget.particle.isReverse) {
      // Implosion animation - hearts get sucked inward
      _radiusAnimation = Tween<double>(begin: widget.particle.distance, end: 0)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
          );

      _floatAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);

      _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.5, 1.0, curve: Curves.easeIn),
        ),
      );

      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 0.8,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.8,
            end: 0.2,
          ).chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 50,
        ),
      ]).animate(_controller);

      _rotationAnimation = Tween<double>(
        begin: widget.particle.rotation,
        end: widget.particle.rotation - (math.pi * 2),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    } else {
      // Explosion animation - hearts expand outward
      _radiusAnimation = Tween<double>(
        begin: 0,
        end: widget.particle.distance,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _floatAnimation = Tween<double>(
        begin: 0,
        end: -widget.particle.floatHeight,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _opacityAnimation = TweenSequence<double>([
        TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 50),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(_controller);

      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.3,
            end: 1.2,
          ).chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.2,
            end: 0.8,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 60,
        ),
      ]).animate(_controller);

      _rotationAnimation = Tween<double>(
        begin: widget.particle.rotation,
        end: widget.particle.rotation + (math.pi * 0.5),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = math.cos(widget.particle.angle) * _radiusAnimation.value;
        final dy =
            math.sin(widget.particle.angle) * _radiusAnimation.value +
            _floatAnimation.value;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: widget.particle.size,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
