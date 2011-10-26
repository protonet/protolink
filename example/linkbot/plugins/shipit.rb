class Shipit < Linkbot::Plugin
    def self.on_message(message, matches)
      squirrels = [
        "http://img.skitch.com/20100714-d6q52xajfh4cimxr3888yb77ru.jpg",
        "https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png"
      ]
      {:image => squirrels[rand(squirrels.length)]}
    end

    Linkbot::Plugin.register('shipit', self,
      {
        :message => {:regex => /ship it/i, :handler => :on_message}
      }
    )
end
