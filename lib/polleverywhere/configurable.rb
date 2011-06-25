module PollEverywhere # :nodoc
  # The configurable mixin is a tiny DSL that instance evals words in
  # a class variable for terse configuration code.
  module Configurable
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      # Pass a block into the instance to configure the attributes on the class
      def configure(&block)
        instance_eval(&block)
      end
    end

    module ClassMethods
      # Setup an instance method on the target class that allows the setting
      # of an attribute both via Class.new.attr = "fun" and Class.new.attr "fun"
      def configurable(*attrs)
        attrs.each do |attr|
          class_eval %{
            attr_writer :#{attr}

            def #{attr}(val=nil)
              val ? self.#{attr} = val : @#{attr}
            end}
        end
      end
    end
  end
end