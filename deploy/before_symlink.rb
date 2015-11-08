# Asset pre-compilation for OpsWorks cook book
run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
run "wget $KANJI_MEISTER_URL config/kanji.yml"
