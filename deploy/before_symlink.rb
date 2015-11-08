# Asset pre-compilation for OpsWorks cook book
run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
run "aws s3 cp s3://$KANJI_MEISTER_CONFIG_FILE config/kanji.yml --region KANJI_MEISTER_BUCKET_REGION"
