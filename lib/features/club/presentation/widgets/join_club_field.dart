import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_state.dart';

class JoinClubField extends StatelessWidget {
  const JoinClubField({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<JoinClubBloc>();
    final controller = TextEditingController();

    return BlocBuilder<JoinClubBloc, JoinClubState>(
      builder: (context, state) {
        return TypeAheadField<Club>(
          builder: (_, ctrl, focusNode) {
            return TextField(
              controller: ctrl,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Rechercher un club',
                suffixIcon: _suffix(state),
              ),
            );
          },
          suggestionsCallback: (pattern) async {
            final query = pattern.trim();
            bloc.add(SearchClubsChanged(query));
            return bloc.stream.firstWhere(
                  (blocState) =>
              blocState.query == query &&
                  (blocState.status == ClubSearchStatus.success ||
                      blocState.status == ClubSearchStatus.empty ||
                      blocState.status == ClubSearchStatus.failure),
            ).then((state) => state.results);
          },
          itemBuilder: (_, club) => ListTile(title: Text(club.name)),
          onSelected: (club) {
            bloc.add(ClubSelected(club));
            controller.text = club.name;
            FocusScope.of(context).unfocus();
          },
          emptyBuilder: (context) {
            if (state.status == ClubSearchStatus.failure) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Text(state.error ?? 'Erreur'),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Aucun résultat'),
            );
          },
        );
      },
    );
  }

  Widget _suffix(JoinClubState state) {
    if (state.status == ClubSearchStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (state.selected != null) return const Icon(Icons.check_circle);
    return const Icon(Icons.search);
  }
}
