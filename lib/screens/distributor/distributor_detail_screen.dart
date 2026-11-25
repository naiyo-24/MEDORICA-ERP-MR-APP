import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/distributor/distributor_contact_card.dart';
import '../../cards/distributor/distributor_description_card.dart';
import '../../cards/distributor/distributor_header_card.dart';
import '../../cards/distributor/distributor_order_info_card.dart';
import '../../provider/distributor_provider.dart';
import '../../theme/app_theme.dart';

class DistributorDetailScreen extends ConsumerStatefulWidget {
  final String distributorId;

  const DistributorDetailScreen({super.key, required this.distributorId});

  @override
  ConsumerState<DistributorDetailScreen> createState() =>
      _DistributorDetailScreenState();
}

class _DistributorDetailScreenState
    extends ConsumerState<DistributorDetailScreen> {
  late ScrollController _scrollController;
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showAppBar) {
      setState(() => _showAppBar = true);
    } else if (_scrollController.offset <= 200 && _showAppBar) {
      setState(() => _showAppBar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final distributorAsync = ref.watch(
      distributorByIdProvider(widget.distributorId),
    );

    return Scaffold(
      appBar: _buildAnimatedAppBar(),
      body: distributorAsync.when(
        data: (distributor) {
          if (distributor == null) {
            return const Center(child: Text('Distributor not found'));
          }

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  DistributorHeaderCard(distributor: distributor),
                  DistributorOrderInfoCard(distributor: distributor),
                  DistributorDescriptionCard(distributor: distributor),
                  DistributorContactCard(distributor: distributor),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString().replaceFirst('Exception: ', ''),
              style: AppTypography.body.copyWith(color: AppColors.quaternary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: _showAppBar
    ? colorScheme.surface
    : colorScheme.surface.withAlpha(0),
      elevation: _showAppBar ? 2 : 0,
      leading: GestureDetector(
        onTap: () => GoRouter.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Iconsax.arrow_circle_left,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      title: _showAppBar
          ? Consumer(
              builder: (context, ref, child) {
                final distributor = ref
                    .watch(distributorByIdProvider(widget.distributorId))
                    .asData
                    ?.value;
                return Text(
                  distributor?.name ?? 'Distributor',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            )
          : null,
      centerTitle: false,
    );
  }
}