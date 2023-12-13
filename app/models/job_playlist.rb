class JobPlaylist < ApplicationRecord
  has_many :playlist_jobs, dependent: :destroy
  has_many :jobs, through: :playlist_jobs
end
