namespace :postgresql do
  task :dump do
    out_file = "andreord_dev.sql"
    sh %{pg_dump -U postgres --no-owner andreord_development > #{out_file}}
    puts "dumping db to #{out_file}"
  end
end
