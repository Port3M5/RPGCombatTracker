JASMINE_NODE = 'jasmine-node'

task :default => [:build, :test]

task :test do |t|
  sh JASMINE_NODE, "--coffee", "--verbose", "spec"
end

task :build do |b|
  sh 'coffeeuglify', '-m lib/*.class.coffee lib/ui.coffee', ' -o ../bin/combattracker'
end
