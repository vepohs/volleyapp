class Role {
  final String id;
  final String name;
  final Set<String> permissions;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  bool hasPermission(String permission) => permissions.contains(permission);

  @override
  String toString() => 'Role(id: $id, name: $name)';
}
