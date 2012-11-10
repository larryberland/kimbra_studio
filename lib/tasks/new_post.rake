require 'rubygems'
require 'optparse'
require 'yaml'

desc "create new post with textmate"
task :np do
  OptionParser.new.parse!
  ARGV.shift
  title = ARGV.join(' ')

  path = "config/jekyll/_posts/#{Date.today}-#{title.downcase.gsub(/[^[:alnum:]]+/, '-')}.markdown"
  
  if File.exist?(path)
  	puts "[WARN] File exists - skipping create"
  else
    File.open(path, "w") do |file|
      file.puts YAML.dump({'layout' => 'default', 'published' => true, 'title' => title, 'comments' => true, 'author' => 'Jim James'})
      file.puts "---"
    end
  end
  `/usr/local/bin/mine #{path}`

  exit 1
end