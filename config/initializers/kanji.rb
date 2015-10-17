kanji_config_path = if Rails.env.test?
  Rails.root.join('spec', 'fixtures', 'kanji.yml')
else
  Rails.root.join('config', 'kanji.yml')
end

Kernel.const_set("KanjiDataPath", kanji_config_path)
