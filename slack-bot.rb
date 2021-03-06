class SlackBot
  def initialize(slack_bot)
    @slack_bot = slack_bot

    register_hello_method
    register_message_method
    register_close_method
    register_closed_method

    @slack_bot.start!
  end

  private

  def register_hello_method
    @slack_bot.on :hello do
      puts "Successfully connected, welcome '#{@slack_bot.self.name}' to the '#{@slack_bot.team.name}' team at https://#{@slack_bot.team.domain}.slack.com."
    end
  end

  def register_message_method
    @slack_bot.on :message do |data|
      data.text.split(' ').each do |word|
        original_word = word

        case word.downcase.gsub(/[^a-z0-9\s]/i, '')
        when '<!here>' then
          @slack_bot.web_client.files_upload(
              channels: data.channel,
              file: Faraday::UploadIO.new("#{Dir.pwd}/images/morpheus.jpg", 'image/jpeg'),
              filename: 'morpheus.jpg',
              initial_comment: "Enough with the SPAM already <@#{data.user}>!"
          )
        when /ol[á|a]|bom dia|hello|good morning/ then
          @slack_bot.message channel: data.channel, text: "Hello <@#{data.user}> :wave:"
        when 'xing' then
          @slack_bot.message channel: data.channel, text: "*XING, dumbass :grammar_nazi:" unless original_word == 'XING'
        when 'kununu' then
          @slack_bot.message channel: data.channel, text: "*kununu, dumbass :grammar_nazi:" unless original_word == 'kununu'
        end
      end
    end
  end

  def register_close_method
    @slack_bot.on :close do |_data|
      puts "Client is about to disconnect..."
    end
  end

  def register_closed_method
    @slack_bot.on :closed do |_data|
      puts "Client has disconnected successfully!"
    end
  end
end
