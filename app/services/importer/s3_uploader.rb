module Importer
  class S3Uploader
    def self.upload(file_path, key)
      obj = S3_BUCKET.object(key)
      obj.upload_file(file_path)
      obj.public_url
      p "Uploaded #{file_path} to #{obj.public_url}"
    end

    def self.file_exists?(key)
      obj = S3_BUCKET.object(key)
      obj.exists?
    end
  end
end
