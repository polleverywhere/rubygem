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
      # Manage a set of properties and easily create instances of values from them.
      class Set < CoreExt::HashWithIndifferentAccess
        # Create a set of of properties that we can use to create instances of value sets
        def initialize
          super() do |props, name|
            props[name] = Property.new(name)
          end
        end

        # Return a collection fo values wrapped inside of a valuset. Valuesets make
        # it easier to query and validate a collection of values.
        def value_set(hash={})
          Value::Set.new(*values.map(&:value))
        end
      end

      include Configurable

      attr_accessor :name, :validations

      configurable :description

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
        # Manage a collection of values so that you can validate, commit, detect changes, etc in bulk
        class Set < CoreExt::HashWithIndifferentAccess
          def initialize(*values, &block)
            # Copy the values and property names into the hash
            values.each do |value|
              props[value.property.name] = value
            end
          end

          # Set the current value so that we can track dirty changes
          def []=(prop_name, value)
            prop(prop_name).current = value
          end

          # Access the current value
          def [](prop_name)
            prop(prop_name).current
          end

          # Returns a hash with a {:attr => ['original', 'changed']}.
          def changes
            props.inject(CoreExt::HashWithIndifferentAccess.new) do |hash, (prop_name, value)|
              hash[prop_name] = value.changes if value.changed?
              hash
            end
          end

          # Detects if all properties have been changed
          def changed?
            props.values.any?(&:changed?)
          end

          # Commit changes
          def commit
            props.values.each(&:commit)
          end

          # Our collection of property values... I call them props under the assumption that they're returning values.
          def props
            @props ||= CoreExt::HashWithIndifferentAccess.new do |hash, key|
              hash[key] = Property.new(key).value
            end
          end

          # Prettier way to get at a prop so it doesn't feel so hashy
          def prop(prop_name)
            props[prop_name]
          end
        end

        attr_reader :property, :original
        attr_accessor :current
        # Make our value DSL prettier so we can ask, value.was and value.is
        alias :is :current
        alias :was :original

        def initialize(property)
          @property = property
        end

        # Detect if the values have changed since we last updated them
        def changed?
          original != current
        end

        # The original and current state of the value if it changed.
        def changes
          [original, current] if changed?
        end

        # Commit the values if they're valid
        def commit
          @original = @current
        end
      end
    end

    module ClassMethods
      # Set or get the root key of the model
      def root_key(name=nil)
        name ? @root_key = name.to_sym : @root_key
      end

      # Define a property at the class level
      def prop(name, &block)
        # Setup instance methods on the class that give us a short cut to the prop values
        class_eval %{
          def #{name}=(val)
            value_set[:#{name}] = val
          end

          def #{name}
            value_set[:#{name}]
          end}
        
        prop_set[name].instance_eval(&block) if block
        # Return the property we just created so we can chain calls
        prop_set[name]
      end

      # A property set that inherits superclass property sets.
      def prop_set
        @prop_set ||= Property::Set.new.merge superclass_prop_set
      end

      # Instanciate a class from a hash
      def from_hash(hash)
        new.from_hash(hash)
      end

    protected
      # Grab attributes from the superclass, clone them, and then we can modify them locally.
      def superclass_prop_set
        (superclass.respond_to?(:prop_set) && superclass.prop_set.clone) || Property::Set.new
      end
    end

    module InstanceMethods
      # A value set instance for this class instance
      def value_set
        @value_set ||= self.class.prop_set.value_set
      end

      # Returns a value from the value_set for a property
      def prop(name)
        value_set.prop(name)
      end

      # Figure out if the model changed.
      def changed?
        value_set.changed?
      end

      def to_hash
        hash = value_set.props.inject CoreExt::HashWithIndifferentAccess.new do |hash, (name, value)|
          hash[name] = self.send(name)
          hash
        end
        # Add a root key if one is specified
        self.class.root_key ? { self.class.root_key => hash } : hash
      end

      # Debug friendly way to output model state
      def to_s
        %(#{self.class.name}(#{value_set.props.map{|name, val|
          "#{name}:#{'`' if val.changed? }#{val.current.inspect}"
        }.join(', ')}))
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