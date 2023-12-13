class PlaylistJob < ApplicationRecord
  belongs_to :job
  belongs_to :job_playlist
end
