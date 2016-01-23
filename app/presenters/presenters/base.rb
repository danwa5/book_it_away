module Presenters
  class Base
    attr_reader :subject

    def initialize(subject)
      @subject = subject
    end

    def self.presents(model)
      define_method(model) { @subject }
    end
  end
end