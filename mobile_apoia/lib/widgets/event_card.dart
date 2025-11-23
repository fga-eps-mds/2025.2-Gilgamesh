import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.nome, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),

              Text(
                event.descricao,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "${event.date.day}/${event.date.month}/${event.date.year}",
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
