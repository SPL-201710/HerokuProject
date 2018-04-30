require "shrine"
require "shrine/storage/s3"
#require "shrine/storage/file_system"
 
Shrine.plugin :activerecord
Shrine.plugin :logging, logger: Rails.logger
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :rack_file # for non-Rails apps
 
s3_options = {
  access_key_id:     ENV['S3_KEY'],
  secret_access_key: ENV['S3_SECRET'],
  region:            ENV['S3_REGION'],
  bucket:            ENV['S3_BUCKET'],
}
 
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
}

#Shrine.storages = {
#  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads_server/cache"),
#  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads_server/store"),
#}
