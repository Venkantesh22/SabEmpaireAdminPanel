import 'package:admin_panel_ak/models/service_model/spin_wheel_winner_model/spin_wheel_winner_model.dart';
import 'package:admin_panel_ak/models/user_model/user_model.dart';
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpinWheelWinnerSection extends StatelessWidget {
  const SpinWheelWinnerSection({
    super.key,
  });

  static const Color _gold =
      Color(0xFFF2C14E);

  static const Color _rubyRed =
      Color(0xFFD7263D);

  @override
  Widget build(BuildContext context) {
    return Consumer<SpinWheelProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        final List<SpinWheelWinnerModel>
            winners =
            provider.spinWheelWinnerList;

        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color:
                AppColor.spinWheelBackgroundColor,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color:
                  _gold.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(
                context,
                provider,
                winners.length,
              ),

              const SizedBox(height: 24),

              _buildBody(
                context,
                provider,
                winners,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    SpinWheelProvider provider,
    int totalWinners,
  ) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _rubyRed.withValues(
              alpha: 0.15,
            ),
            border: Border.all(
              color:
                  Colors.black.withValues(
                alpha: 0.50,
              ),
            ),
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            color: _gold,
            size: 28,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Spin & Bling Winners',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '$totalWinners total reward${totalWinners == 1 ? '' : 's'} claimed',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Refresh Winners',
          onPressed:
              provider.isWinnerLoading
                  ? null
                  : () {
                      provider
                          .loadSpinWheelWinners();
                    },
          icon:
              provider.isWinnerLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _gold,
                      ),
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      color: _gold,
                    ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    SpinWheelProvider provider,
    List<SpinWheelWinnerModel> winners,
  ) {
    if (provider.isWinnerLoading &&
        winners.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(
            color: _gold,
          ),
        ),
      );
    }

    if (provider.winnerErrorMessage != null &&
        winners.isEmpty) {
      return _buildError(
        provider,
      );
    }

    if (winners.isEmpty) {
      return _buildEmpty();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile =
            constraints.maxWidth < 650;

        if (isMobile) {
          return _buildMobileList(
            winners,
          );
        }

        return _buildDesktopTable(
          winners,
        );
      },
    );
  }

  Widget _buildMobileList(
    List<SpinWheelWinnerModel> winners,
  ) {
    return Column(
      children:
          winners.map(
        (
          SpinWheelWinnerModel winner,
        ) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 12,
            ),
            child: _buildWinnerCard(
              winner,
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildWinnerCard(
    SpinWheelWinnerModel winner,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              _gold.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildRewardIcon(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      winner.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      winner.userId,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _buildWonBadge(),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: _gold,
                size: 16,
              ),

              const SizedBox(width: 6),

              Text(
                _formatDate(
                  winner.dateOfCreate,
                ),
                style:
                    const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              Text(
                winner.offer,
                style:
                    const TextStyle(
                  color: _gold,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildDesktopTable(
  List<SpinWheelWinnerModel> winners,
) {
  return Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColor.spinWheelCardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColor.spinWheelBorderColor,
      ),
    ),
    child: LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: DataTable(
              headingRowHeight: 54,
              dataRowMinHeight: 72,
              dataRowMaxHeight: 82,
              horizontalMargin: 20,
              columnSpacing: 30,

              headingTextStyle:
                  const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    AppColor.spinWheelTitleColor,
              ),

              headingRowColor:
                  WidgetStateProperty.all(
                AppColor.spinWheelCardColor,
              ),

              columns: const [
                DataColumn(
                  label: Text('USER'),
                ),
                DataColumn(
                  label: Text('EMAIL'),
                ),
                DataColumn(
                  label: Text('MOBILE'),
                ),
                DataColumn(
                  label: Text('REWARD'),
                ),
                DataColumn(
                  label: Text('DATE & TIME'),
                ),
                DataColumn(
                  label: Text('OFFER'),
                ),
                DataColumn(
                  label: Text('STATUS'),
                ),
              ],

              rows: winners.map(
                (
                  SpinWheelWinnerModel winner,
                ) {
                  final UserModel? user =
                      winner.user;

                  return DataRow(
                    cells: [
                      // USER
                      DataCell(
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            _buildRewardIcon(
                              size: 38,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            SizedBox(
                              width: 170,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    user?.name
                                                ?.isNotEmpty ==
                                            true
                                        ? user!.name
                                        : 'Unknown User',
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color: AppColor
                                          .spinWheelTitleColor,
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 3,
                                  ),

                                  Text(
                                    winner.userId,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color: AppColor
                                          .serviceTapTextColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // EMAIL
                      DataCell(
                        SizedBox(
                          width: 210,
                          child: Text(
                            user?.email
                                        ?.isNotEmpty ==
                                    true
                                ? user!.email
                                : '-',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              color: AppColor
                                  .serviceTapTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      // MOBILE
                      DataCell(
                        Text(
                          user?.phone
                                      ?.isNotEmpty ==
                                  true
                              ? user!.phone
                              : '-',
                          style:
                              const TextStyle(
                            color: AppColor
                                .serviceTapTextColor,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),

                      // REWARD
                      DataCell(
                        SizedBox(
                          width: 160,
                          child: Text(
                            winner.title,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              color: AppColor
                                  .spinWheelTitleColor,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // DATE
                      DataCell(
                        Text(
                          _formatDate(
                            winner.dateOfCreate,
                          ),
                          style:
                              const TextStyle(
                            color: AppColor
                                .serviceTapTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // OFFER
                      DataCell(
                        Text(
                          winner.offer,
                          style:
                              const TextStyle(
                            color: AppColor
                                .spinWheelTitleColor,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      // STATUS
                      DataCell(
                        _buildWonBadge(),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    ),
  );
}
  Widget _buildRewardIcon({
    double size = 44,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            _gold.withValues(
          alpha: 0.15,
        ),
        border: Border.all(
          color:
              _gold.withValues(
            alpha: 0.30,
          ),
        ),
      ),
      child: Icon(
        Icons.card_giftcard_rounded,
        color: _gold,
        size: size * 0.50,
      ),
    );
  }

  Widget _buildWonBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFF2E7D32)
                .withValues(
          alpha: 0.18,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xFF66BB6A)
                  .withValues(
            alpha: 0.40,
          ),
        ),
      ),
      child: const Text(
        'WON',
        style: TextStyle(
          color:
              Color(0xFF81C784),
          fontSize: 10,
          fontWeight:
              FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.card_giftcard_outlined,
            color: Colors.white24,
            size: 56,
          ),
          SizedBox(height: 14),
          Text(
            'No winners yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Users who win Spin & Bling rewards will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    SpinWheelProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: _rubyRed,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            provider.winnerErrorMessage ??
                'Something went wrong.',
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              provider
                  .loadSpinWheelWinners();
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'RETRY',
            ),
            style:
                ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor:
                  Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(
    DateTime date,
  ) {
    return DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(date);
  }
}