%w(social_cards).each do |folder|
  run "ln -nfs #{config.shared_path}/public/#{folder} #{config.release_path}/public/#{folder}"
end
