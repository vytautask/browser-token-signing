module MiscMethods

  # irb-like mode

  # this method gives you raw Ruby power during runtime
  # call this method ONLY for runtime debugging and remove it before commit
  def irb vars=binding


    puts "Entering into interpretator mode. Enter any Ruby commands you want."
    puts "All entered commands will be stored in 'cmds' array."
    puts "Enter 'dump_irb' to dump cmds into file."
    puts "Enter 'break' to exit this mode."


    file_name, line_no = caller[0].scan(/(.*):(\d+)/).flatten
    line_no = line_no.to_i

    cmds = []

    while true
      print "cmd: "
      cmd = STDIN.gets.strip

      if cmd == "dump_irb"
        puts "dumping cmds to:"
        puts "#{file_name}:#{line_no + 1}"
        separator = ["###### SOURCE GENERATED BY IRB METHOD ######"]
        data = File.readlines(file_name)

        File.open(file_name, "w") do |f|
          f.puts data[0..line_no - 1] + separator + cmds + separator +
            data[line_no..-1]
        end

        line_no += cmds.size + 2
        cmds = []
        next
      elsif cmd == "exit"
        exit
      end

      begin
        t = Time.now
        out = eval(cmd, vars)
        t = Time.now - t

        cmds << cmd unless cmd =~ /^cmds(\.?)/ || cmd == "dump_irb"
        out_str = "(#{t})"
        out_str += " #{out.inspect}" unless out.nil?
        puts out_str
      rescue Exception => e
        puts e
        puts e.backtrace[0..7]
      end
    end

    puts "Exiting interpretator mode."
  end
end
