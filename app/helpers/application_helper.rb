module ApplicationHelper
  
  def s3_base_url
    return CONFIG[:aws_s3_bucket_url]
  end
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
