class Micropost < ActiveRecord::Base
  belongs_to :user
  #使用了“箭头”句法，表示一种对象，叫 Proc（procedure）或 
  #lambda，即“匿名函数”（没有名字的函数）。
  #-> 接受一个代码块，返回一个 Proc。
  #然后在这个 Proc 上调用 call 方法执行其中的代码。
  mount_uploader :picture,PictureUploader
  default_scope -> {order(created_at: :desc)}
  validates :user_id,presence:true
  validates :content,presence:true,length:{maximum:140}
  validate  :picture_size

  private
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture,"should be less than 5MB")
  		end
  	end
end
