class user_obj{
  String userid;
  String username;
  String role;

  user_obj(this.userid, this.username, this.role);

  @override
  String toString() {
    return 'user_obj{userid: $userid, username: $username, role: $role}';
  }
}