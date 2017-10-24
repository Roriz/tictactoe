require 'i18n'
require 'pry'

I18n.config.available_locales = :en
I18n.config.load_path = Dir[File.expand_path('../../../assets/nls/*.yml', Pathname.new(__FILE__).realpath)]
I18n.backend.load_translations
