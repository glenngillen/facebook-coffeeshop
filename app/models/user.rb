class User
  attr_accessor :id, :name, :friends

  def initialize(user)
    @client         = user.client
    self.id         = user.id
    self.name       = user.name
    self.friends    = user.friends
    super
  end

  def url_likes
    @url_likes ||= client.fql_query(
      "SELECT url
       FROM url_like
       WHERE user_id = me()").map{|hash| hash.values}.flatten
  end

  def liked?(url)
    url_likes.detect{|liked_url| liked_url =~ /\A#{url}/}
  end

  def friends_using_app
    @friends_using_app ||= client.fql_query(
      "SELECT uid, name, is_app_user, pic_square
       FROM user
       WHERE uid in
         (SELECT uid2 FROM friend WHERE uid1 = me())
       AND is_app_user = 1") || []
  end

  private
  def client
    @client
  end
end
