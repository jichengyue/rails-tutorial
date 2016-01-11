module UsersHelper
  #返回指定用户的Gravatar
  def gravatar_for(user,option={})
  	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  	gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  	image_tag(gravatar_url,alt:user.name,class:"gravatar",:size=>"#{option[:size]}")
  end

  # def gravatar_for_size(user,size)
  #   gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  #   gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  #   image_tag(gravatar_url,alt:user.name,class:"gravatar",:height=>"#{size}")
  # end
end
