import 'package:flutter/material.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_club_by_id/get_club_by_id_params.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_club_by_id/get_club_by_id_use_case.dart';
import 'package:volleyapp/features/event/domain/entities/event.dart';
import 'package:volleyapp/features/event/domain/entities/match_details.dart';
import 'package:volleyapp/features/event/domain/entities/training_details.dart';
import 'package:volleyapp/features/team/domain/use_cases/get_team_by_id/get_team_by_id_params.dart';
import 'package:volleyapp/features/team/domain/use_cases/get_team_by_id/get_team_by_id_use_case.dart';


Future<String> resolveClubName(String clubId) async {
  final useCase = locator<GetClubByIdUseCase>();
  final result = await useCase(GetClubByIdParams(clubId: clubId));

  return result.fold(
        (failure) => "Club inconnu",
        (club) => club.name,
  );
}
Future<String> resolveTeamName(String teamId) async {
  final useCase = locator<GetTeamByIdUseCase>();
  final result = await useCase(GetTeamByIdParams(teamId: teamId));

  return result.fold(
        (failure) => "Equipe inconnu",
        (team) => team.name,
  );
}
enum EventStatus { upcoming, live, finished }

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final status = _computeStatus(event, DateTime.now());
    final isMatch = event.details is MatchDetails;
    final isTraining = event.details is TrainingDetails;

    final title = isMatch
        ? _matchTitle(event.details as MatchDetails)
        : "Entraînement";

    final subtitle = _dateTimeRangeLabel(event.startAt, event.endAt);
    final location = event.location;

    final trailing =
    isMatch ? _matchTrailing(status, event.details as MatchDetails) : null;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            _statusChip(status),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 16),
                const SizedBox(width: 4),
                Flexible(child: Text(location, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
        trailing: trailing,
        children: [
          if (isMatch)
            _matchExpanded(context, event.details as MatchDetails, status),
          if (isTraining)
            _trainingExpanded(context, event.details as TrainingDetails),
        ],
      ),
    );
  }

  EventStatus _computeStatus(Event e, DateTime now) {
    if (now.isBefore(e.startAt)) return EventStatus.upcoming;
    if (now.isAfter(e.endAt)) return EventStatus.finished;
    return EventStatus.live;
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _dateTimeRangeLabel(DateTime start, DateTime end) {
    final startDay = "${_two(start.day)}/${_two(start.month)}/${start.year}";
    final startH = "${_two(start.hour)}:${_two(start.minute)}";

    final endDay = "${_two(end.day)}/${_two(end.month)}/${end.year}";
    final endH = "${_two(end.hour)}:${_two(end.minute)}";

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return "$startDay  •  $startH–$endH";
    }

    return "$startDay $startH → $endDay $endH";
  }


  String _matchTitle(MatchDetails d) {
    final compo = d.competition != null && d.competition!.isNotEmpty
        ? " • ${d.competition}"
        : "";
    return "Match$compo";
  }

  Widget _statusChip(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return const _Chip(label: "À venir");
      case EventStatus.live:
        return const _Chip(label: "En cours", isAccent: true);
      case EventStatus.finished:
        return const _Chip(label: "Terminé");
    }
  }

  Widget? _matchTrailing(EventStatus status, MatchDetails d) {
    if (status != EventStatus.finished) return const Icon(Icons.expand_more);
    final r = d.result;
    if (r == null) return const Icon(Icons.expand_more);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${r.homeSets}-${r.awaySets}",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        const Icon(Icons.expand_more),
      ],
    );
  }

  Widget _matchExpanded(BuildContext context, MatchDetails d, EventStatus status) {
    final r = d.result;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: Future.wait([
            resolveClubName(d.homeClubId),
            resolveTeamName(d.homeTeamId),
            resolveClubName(d.awayClubId),
            resolveTeamName(d.awayTeamId),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Chargement...");
            final data = snapshot.data!;
            return _kv("Clubs/Équipes", "${data[0]} (${data[1]}) vs ${data[2]} (${data[3]})");
          },
        ),
        if (d.competition != null && d.competition!.isNotEmpty)
          _kv("Compétition", d.competition!),
        const SizedBox(height: 8),
        if (status == EventStatus.finished && r != null) ...[
          Text("Résultat final : ${r.homeSets}-${r.awaySets}",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (r.sets.isEmpty) const Text("Aucun détail des sets."),
          if (r.sets.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.sets.map((s) {
                final line = "Set ${s.number} : ${s.homePoints}-${s.awayPoints}";
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(line),
                );
              }).toList(),
            ),
        ] else if (status == EventStatus.live) ...[
          const Text("Le match est en cours..."),
        ] else ...[
          const Text("Le match n’a pas encore commencé."),
        ],
      ],
    );
  }

  Widget _trainingExpanded(BuildContext context, TrainingDetails d) {
    return FutureBuilder(
      future: Future.wait([
        resolveClubName(d.clubId),
        resolveTeamName(d.teamId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Chargement...");
        final data = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kv("Club", data[0]),
            _kv("Équipe", data[1]),
            if (d.coachId != null) _kv("Coach", d.coachId!),
            if (d.notes != null && d.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(d.notes!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        );
      },
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$k : ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isAccent;
  const _Chip({required this.label, this.isAccent = false});

  @override
  Widget build(BuildContext context) {
    final bg = isAccent
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final fg = isAccent
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}
