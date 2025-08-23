import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) {
        final place = places[index];
        return ListTile(
          title: Text(
            place.title,
            style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
              color: Theme.of(ctx).colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }
}
