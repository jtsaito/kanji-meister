file = Rails.root.join('config', 'single_page_app_assets.yml')

config = YAML.load(ERB.new(File.read(file)).result).with_indifferent_access[Rails.env]
struct = OpenStruct.new(config)

Kernel.const_set("SinglePageAssetConfig", struct)
