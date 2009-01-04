%w( date_ext date_column ).each do |f|
  require File.join(File.dirname(__FILE__), "lib/#{f}")
end

ActiveRecord::Base.send(:include, DateColumn::Mixin)
