import 'package:flutter/material.dart';
import 'package:leeds_library/data/models/app_user.dart';

class UserProfileCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onLogout;

  const UserProfileCard({
    Key? key,
    required this.user,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.photoUrl;
    final avatarLetter = user.name?.isNotEmpty == true
        ? user.name![0].toUpperCase()
        : '?';

    print("User avatar url = $avatarUrl");

    return  Center(

        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? Text(
                  avatarLetter,
                  style: const TextStyle(fontSize: 32),
                )
                    : null,
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                user.name ?? 'No name',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              // Email
              Text(
                user.email ?? 'No email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 4),

              // Role
              Text(
                'Role: ${user.role ?? 'unknown'}',
                style: Theme.of(context).textTheme.labelLarge,
              ),

              const SizedBox(height: 44),

              // Logout Button
              ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),

    );
  }
}