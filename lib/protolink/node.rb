module Protolink
  class Node
    attr_reader :id, :uuid, :name, :description

    def initialize(connection, attributes = {})
      @connection   = connection
      @id           = attributes['id']
      @uuid         = attributes['uuid']
      @name         = attributes['name']
      @description  = attributes['description']
      @loaded     = false
    end

    def coupled?
      connection.get("/api/v1/couplings/#{id}")
    end

    protected
      def connection
        @connection
      end

  end
end