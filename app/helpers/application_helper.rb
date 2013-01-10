module ApplicationHelper
  
  def s3_base_url
    return ENV["GRE340_S3_BUCKET_URL"]
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
