module Lita
  module Actions
    class Base
      include Lita::Handler::Common

      attr :response
      @@template_root = nil

      def initialize(response)
        @response = response
      end

      def self.template_root(path = nil)
        @@template_root = path if path
        @@template_root
      end

      def robot
        response.message.instance_variable_get :"@robot"
      end

      def translate(key, options = {})
        I18n.translate("lita.handlers.team.#{key}", options)
      end
      alias_method :t, :translate
    end
  end
end
