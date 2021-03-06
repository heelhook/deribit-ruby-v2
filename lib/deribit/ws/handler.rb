module Deribit
  class WS
    class Handler < BaseHandler
      attr_accessor :subscriptions, :access_token

      def initialize
        @subscriptions = []
        super
      end

      # test request response
      def heartbeat(json)
        # debug
        # puts "GOT HEARTBEAT, json: #{json}"
        if json.dig(:params, :type) == "test_request"
          ws.test
        end
      end

      def subscribe(json)
        if json[:result]
          @subscriptions += json[:result]
        else
          raise "Received a subscribe call without a json[:result]: #{json.inspect}"
        end
      end

      def unsubscribe(json)
        channels = json[:result]
        channels.each { |ch| @subscriptions.delete(ch) }
      end

      def auth(json)
        @access_token = json.dig(:result, :access_token)
      end

      def subscription(json)
        channel = json.dig(:params, :channel)
        data = json.dig(:params, :data)

        puts "GOT subscription EVENT: #{json}"
      end
    end
  end
end
