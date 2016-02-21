# kanji-meister
Simple Kanji Flash Cards (Heisig style)

# Setup

## Database
Setup database with UTF-8 encoding.

## Test
Run tests with `bundle exec rspec`.

# Notes on Using AWS OpsWorks
To get this repo running on OpsWorks I mainly stuck to [Alex Wood's tutorial](https://ruby.awsblog.com/post/Tx7FQMT084INCR/Deploying-Ruby-on-Rails-Applications-to-AWS-OpsWorks). However, two fixes were needed.

**Fix 1.** Add `username` and `database` to custom JSON in the stack
settings. These were missing. The custom JSON from and should look as follows.

```
{
  "deploy":
  {
    "kanji-meister":
    {
      "database":
      {
        "adapter": "mysql2",
        "database": "kanji-meister_production",
        "username": "root"
      }
    }
  }
}
```

Note that the OpsWork Chef cookbook will replace
`config/database.yml` and insert a production settings block.

**Fix 2*.* The `rubyracer` gem had to be added to the repo's Gemfile. It appears to be are required for `rake db migrate`.

# Kanji data
The application expects the kanji data to be present as
`config/kanji.yml`. Its format can be found in the fixtures.
Using the before symlink hook provided by the default
AWS OpsWorks stack, the file is downloaded from a URL
provided by the KANJI_MEISTER_URL environment variable.

# Single Page App
Currently, the main frontend interaction is provided by a single page app.
The app's assets are entirely served from S3. The latest assets' bucket and
file names are provided from a DynamoDB table. The table allows rolling out
the single page app independently of the backend API (i.e., this rails app).
The settings for the table are stored in `config/single_page_app_assets.yml`.
Moreover, we require the EC2 instance to have AIM policies to access 
the DyanmoDB table.
