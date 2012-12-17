desc 'Run Jekyll in config/jekyll directory without having to cd there. Use this to compile blog posts.'
task :generate do
  Dir.chdir("config/jekyll") do
    system('jekyll')
  end
end