class Awwyeah < Linkbot::Plugin
    def self.on_message(message, matches)
      {:image => "http://i.imgur.com/Y3Q0Z.png"}
    end

    Linkbot::Plugin.register('aw+yeah', self,
      {
        :message => {:regex => /a+w+ y+e+a+h+/i, :handler => :on_message}
      }
    )
end
