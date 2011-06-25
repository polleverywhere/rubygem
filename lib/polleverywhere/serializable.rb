require 'json'

module PollEverywhere
  module Serializable
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
    end

    # Property is somewhat of a metaclass that stores validations, name, etc.
    # for the fields that belond to a serializable model. Since a Property lives 
    # at the class level, we have a Value class that 
    class Property
      attr_accessor :name, :validations, :description

      def initialize(name, configuration={})
        self.name = name.to_sym
        # Set attributes on the class from a given hash
        configuration.each do |attr, args|
          self.send("#{attr}=", *args) if self.respond_to? "#{attr}="
        end
      end

      def value
        Value.new(self)
      end

      # Contains the value of the property, runs validations, and
      # tracks property changes
      class Value
        attr_reader :property, :original
        attr_accessor :current

        def initialize(property)
          @property = property
        end
      end
    end

    module ClassMethods
      # Set or get the root key of the model
      def root_key(name=nil)
        name ? @name = name.to_sym : @name
      end

      def prop(name)
        props[name]
      end

      # Setup attributes hash and delegate setters/getters to the base class.
      def props
        @props ||= Hash.new do |props,name|
          # Setup the attribute class
          props[name] = Property.new(name)

          # Define the methods at the instance level
          class_eval %{
            def #{name}=(val)
              props[:#{name}].current = val
            end

            def #{name}
              props[:#{name}].current
            end}

        end.merge superclass_props
      end

      # Instanciate a class from a hash
      def from_hash(hash)
        new.from_hash(hash)
      end

    protected
      # Grab attributes from the superclass, clone them, and then we can modify them locally.
      def superclass_props
        (superclass.respond_to?(:props) && superclass.props.clone) || {}
      end
    end

    module InstanceMethods
      def props
        @props ||= self.class.props.inject CoreExt::HashWithIndifferentAccess.new do |hash, (name, property)|
          hash[property.name] = property.value
          hash
        end
      end

      def to_hash
        hash = props.inject CoreExt::HashWithIndifferentAccess.new do |hash, (name, value)|
          hash[name] = self.send(name)
          hash
        end
        # Add a root key if one is specified
        self.class.root_key ? { self.class.root_key => hash } : hash
      end

      # Set the attributes from a hash
      def from_hash(hash)
        hash = CoreExt::HashWithIndifferentAccess.new(hash)
        # Pop off the root key if one is specified and given
        self.class.root_key and hash[self.class.root_key] and hash = hash[self.class.root_key]
        # Then set the attributes on the klass if they're present
        hash.each do |name, value|
          self.send("#{name}=", value) if self.respond_to? name
        end
        self
      end

      def to_json
        JSON.pretty_generate(to_hash)
      end

      def from_json(json)
        from_hash JSON.parse(json)
      end
    end
  end

end