class File

  def self.get_tar_top_folders_name(archive_path)
    `tar -ztf #{archive_path}`.split("\n").map {|line| line.split('/')[0]}.uniq
  end

end