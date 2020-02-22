# frozen_string_literal: true

module Company
  attr_accessor :company
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def instances
      self.instances ||= 0
    end
  end

  module InstanceMethods
    def instances_quantity
      self.class.instances += 1
    end
  end
end
