module Importer
  class S3Uploader
    def self.upload(file_path, key)
      obj = S3_BUCKET.object(key)
      obj.upload_file(file_path)
      obj.public_url
    end

    def self.file_exists?(key)
      obj = S3_BUCKET.object(key)
      obj.exists?
    end
  end
end
