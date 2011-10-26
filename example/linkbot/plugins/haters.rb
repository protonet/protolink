class Shipit < Linkbot::Plugin
    def self.on_message(message, matches)
      haters = [
        "http://www.hatersgoingtohate.com/wp-content/uploads/2010/06/haters-gonna-hate-rubberband-ball.jpg",
        "http://www.hatersgoingtohate.com/wp-content/uploads/2010/06/haters-gonna-hate-cat.jpg",
        "http://jesad.com/img/life/haters-gonna-hate/haters-gonna-hate01.jpg",
        "http://i671.photobucket.com/albums/vv78/Sinsei55/HatersGonnaHatePanda.jpg",
        "http://24.media.tumblr.com/tumblr_lltwmdVpoL1qekprfo1_500.gif"
      ]
      {:image => haters[rand(haters.length)]}
    end

    Linkbot::Plugin.register('haters', self,
      {
        :message => {:regex => /haters/i, :handler => :on_message}
      }
    )
end

