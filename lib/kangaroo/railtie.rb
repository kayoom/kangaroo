module Kangaroo
  class Railtie < Rails::Railtie
    initializer 'kangaroo.initialize' do
      begin
        Kangaroo.initialize File.join(Rails.root, %w(config kangaroo.yml)), Rails.logger
      rescue Errno::ECONNREFUSED => e
        Rails.logger.error "Could not connect to OpenERP XML-RPC Service."
      end
    end
  end
end