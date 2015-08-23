# ensure presensce of fixtures for specs

Kernel.send(:remove_const, "KanjiDataPath")
Kernel.const_set("KanjiDataPath", Rails.root.join('spec', 'fixtures', 'kanji.yml'))
