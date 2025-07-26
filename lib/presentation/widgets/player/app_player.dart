import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/presentation/widgets/player/bloc/app_player_bloc.dart';
import 'package:stories_data/models/story_model.dart';

class AppPlayer extends StatelessWidget {
  const AppPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPlayerBloc, AppPlayerState>(
      builder: (context, state) {
        switch (state.status) {
          case AppPlayerStatus.initial:
          case AppPlayerStatus.hide:
            return const SizedBox.shrink();
          case AppPlayerStatus.show:
            return const PlayerWidget();
          case AppPlayerStatus.failure:
            return Center(
              child: Text(state.exception?.message ?? "Неизвестная ошибка"),
            );
        }
      },
    );
  }
}

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        child: Material(
          color: AppColors.hexFFFFFF.withAlpha(0),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.hex5F3430,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: ()=>context.read<AppPlayerBloc>().add(const AppPlayerHide()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.hexFFFFFF,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.hexFFFFFF),
                    ),
                    child: Icon(Icons.close, color: AppColors.hex5F3430),
                  ),
                ),
               
                Expanded(
                  child:
                      BlocSelector<AppPlayerBloc, AppPlayerState, StoryModel?>(
                        selector: (state) {
                          return state.story;
                        },
                        builder: (context, story) {
                          return Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                story?.title ?? 'Название',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.s14hFFFFFFn,
                              ),
                            ],
                          );
                        },
                      ),
                ),
                const ButtonPlayPauseState(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonPlayPauseState extends StatefulWidget {
  const ButtonPlayPauseState({super.key});

  @override
  State<ButtonPlayPauseState> createState() => _ButtonPlayPauseStateState();
}

class _ButtonPlayPauseStateState extends State<ButtonPlayPauseState> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppPlayerBloc, AppPlayerState, bool>(
      selector: (state) {
        return state.isPlaying;
      },
      builder: (context, isPlaying) {
        return GestureDetector(
          onTap: () {
            context.read<AppPlayerBloc>().add(
              isPlaying ? const AppPlayerPause() : const AppPlayerPlay(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.hexFFFFFF,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hexFFFFFF),
            ),
            child: Icon(
              isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
              color: AppColors.hex5F3430,
            ),
          ),
        );
      },
    );
  }
}
