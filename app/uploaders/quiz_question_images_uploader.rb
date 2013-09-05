# encoding: utf-8'

class QuizQuestionImagesUploader < CarrierWave::Uploader::Base

  attr_accessor :quiz_id

  # Include RMagick or ImageScience support:
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :fog

  def store_dir
    "uploads/quiz/#{quiz_id}/quiz_question_images"
  end
  
  # CAUTION: We are going over all the files here.
  # TODO: We need to optimize this sometime in future.
  def delete_all_images
    fog_storage = get_fog_storage
    bucket = get_bucket
    
    directory = fog_storage.directories.get(bucket)
               
    return_string = ""           
                           
    directory.files.each do |file|
      
      return_string += file.key
      
      if ( file.key.to_s.start_with? "uploads/quiz/#{quiz_id}/quiz_question_images/")
        file.destroy
      end  
    end
    
    return return_string
  end
  
  # CAUTION: We are going over all the files here.
  # TODO: We need to optimize this sometime in future.
  def uploaded_images_count
    fog_storage = get_fog_storage
    bucket = get_bucket
    
    directory = fog_storage.directories.get(bucket)
               
    images_count = 0           
                           
    directory.files.each do |file|
      
      if ( file.key.to_s.start_with? "uploads/quiz/#{quiz_id}/quiz_question_images/")
        images_count += 1
      end  
    end
    
    return images_count
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end
  
  def get_fog_storage
    return Fog::Storage.new( :provider => 'AWS',
                        :aws_access_key_id => CONFIG[:aws_access_key_id], 
                        :aws_secret_access_key => CONFIG[:aws_access_key],
                        :region => "us-east-1" )
  end
  
  def get_bucket
    return CONFIG[:aws_s3_bucket]
  end

end