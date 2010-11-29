module Kangaroo
  class Railtie < Rails::Railtie
    initializer 'kangaroo.initialize' do
      Kangaroo.initialize File.join(Rails.root, %w(config kangaroo.yml))
    end
  end
end