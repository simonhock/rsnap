# fetch bower packages before comiling assets
# task "assets:precompile" => "bower:install"
Rake::Task["assets:precompile"].clear
namespace :assets do
  task 'precompile' do
      puts "Not pre-compiling assets..."
  end
end