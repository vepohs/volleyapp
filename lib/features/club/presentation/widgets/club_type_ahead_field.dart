import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_request_bloc.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_request_event.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_request_state.dart';
class ClubTypeAheadField extends StatefulWidget {
  const ClubTypeAheadField({super.key});
  @override
  State<ClubTypeAheadField> createState() => _ClubTypeAheadFieldState();
}

class _ClubTypeAheadFieldState extends State<ClubTypeAheadField> {
  TextEditingController? _controllerFromTypeAhead;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ClubSearchBloc>();

    return BlocBuilder<ClubSearchBloc, ClubSearchState>(
      builder: (context, state) {
        return TypeAheadField<Club>(
          builder: (_, controller, focusNode) {
            _controllerFromTypeAhead = controller;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Rechercher un club',
              ),
            );
          },
          suggestionsCallback: (pattern) async {
            final p = pattern.trim();
            bloc.add(SearchClubsChanged(p));
            final s = await bloc.stream.firstWhere(
                  (s) =>
              s.query == p &&
                  (s.status == ClubSearchStatus.success ||
                      s.status == ClubSearchStatus.empty ||
                      s.status == ClubSearchStatus.failure),
            );
            return s.results;
          },

          itemBuilder: (_, club) => ListTile(title: Text(club.name)),
          onSelected: (club) {
            bloc.add(ClubSelected(club));
            _controllerFromTypeAhead?.text = club.name;
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

  Widget _suffix(ClubSearchState state) {
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
