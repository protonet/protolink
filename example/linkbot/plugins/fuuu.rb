class Fuu < Linkbot::Plugin
    def self.on_message(message, matches)
      {:image => "http://imgur.com/M4KFN.jpg"}
    end
    
    Linkbot::Plugin.register('fuuu', self,
      {
        :message => {:regex => /fu+/i, :handler => :on_message}
      }
    )
end

