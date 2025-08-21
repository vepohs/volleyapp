import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'package:volleyapp/features/club/presentation/blocs/join_club_request_bloc/join_club_request_bloc.dart';
import 'package:volleyapp/features/club/presentation/widgets/club_type_ahead_field.dart';

class JoinClubPage extends StatelessWidget {

  const JoinClubPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClubSearchBloc(locator<GetFilteredClubByNameUseCase>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rejoindre un club'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: ClubTypeAheadField(),
        ),
      ),
    );
  }
}
