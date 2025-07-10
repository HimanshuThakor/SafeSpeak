import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safespeak/Providers/FamilyProvider.dart';
import 'package:safespeak/models/FamilyMemberModel.dart';
import 'package:safespeak/view/Family/AddFamilyMemberScreen.dart';

class FamilyMembersListScreen extends ConsumerStatefulWidget {
  const FamilyMembersListScreen({super.key});

  @override
  ConsumerState<FamilyMembersListScreen> createState() =>
      _FamilyMembersListScreenState();
}

class _FamilyMembersListScreenState
    extends ConsumerState<FamilyMembersListScreen> {
  @override
  void initState() {
    super.initState();
    // Call getFamilyMembers when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(familyMembersProvider.notifier).getFamilyMembers();
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, EmergencyContact member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Family Member'),
          content: Text('Are you sure you want to delete ${member.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                // Call the remove function and check the result
                bool success = await ref
                    .read(familyMembersProvider.notifier)
                    .removeFamilyMember(member.id);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${member.name} deleted successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to delete ${member.name}. Please try again.'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(familyMembersProvider);
    final familyState = ref.watch(familyMembersProvider);
    final isLoading = familyState.isLoading;
    final familyMembers = familyState.familyMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(familyMembersProvider.notifier).getFamilyMembers();
            },
          ),
        ],
      ),
      body: state.isLoading && state.familyMembers == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading family members...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : familyMembers == null || familyMembers.emergencyContact.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.family_restroom,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No family members added yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(familyMembersProvider.notifier)
                        .getFamilyMembers();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: familyMembers.emergencyContact.length,
                    itemBuilder: (context, index) {
                      final member = familyMembers.emergencyContact[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade600,
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            member.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member.phone),
                              if (member.email.isNotEmpty)
                                Text(member.email,
                                    style: TextStyle(color: Colors.grey[600])),
                              if (member.relationship.isNotEmpty)
                                Text('Relationship: ${member.relationship}',
                                    style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          trailing: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddFamilyMemberScreen(
                                              memberToEdit: member,
                                              memberId: member.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        _showDeleteConfirmation(
                                            context, ref, member);
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddFamilyMemberScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
