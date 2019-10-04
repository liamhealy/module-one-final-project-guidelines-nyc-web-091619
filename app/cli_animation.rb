def animation
        5.times do
        i = 1
        while i < 16
            print "\033[2J"
            File.foreach("app/motion/#{i}.txt"){|f| puts f}
            sleep(0.08)
            i += 1
        end
    end
end

animation