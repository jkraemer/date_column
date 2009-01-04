module DateColumn
  module Mixin
    def self.included(base)
      base.extend(ActMethod)
    end

    module ActMethod
      def date_column(*names)
        options = names.extract_options!
        options[:offset] ||= 0
        unless included_modules.include?(InstanceMethods)
          class_inheritable_accessor :date_attributes
          include  InstanceMethods
          before_validation :set_date_attributes
        end
        names.each do |name|
          valuename = :"#{name}_value"
          (self.date_attributes ||= {})[name] = options
          default = options[:default]
          attr_writer valuename
          define_method valuename do
            unless val = instance_variable_get(:"@#{valuename}")
              if orig_val = (send(name) || (!default.blank? and eval(default)))
                orig_val = orig_val - options[:offset]
              else
                orig_val = Time.now
              end
              val = I18n.l(orig_val.to_date)
              instance_variable_set(:"@#{valuename}", val)
            end
            return val
          end
          validates_format_of valuename, :with => /^\d\d?.\d\d?.\d{4}$/, :message => 'Bitte geben Sie das Datum im Format DD.MM.JJJJ an.'
        end
      end

      module InstanceMethods
        protected
          def set_date_attributes
            date_attributes.each do |attr_name, options|
              date = Date.parse_de(send :"#{attr_name}_value") # rescue Time.now
              send("#{attr_name}=", (date + options[:offset]))
            end
          end
      end

    end # ActMethod
  end # Mixin

end
