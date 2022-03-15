class Community {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? boardId;
  final String? userId;
  final String? like_count;
  final String? region;

  Community(
      {this.id,
      this.title,
      this.contents,
      this.datetime,
      this.boardId,
      this.userId,
      this.like_count,
      this.region});
}
