# frozen_string_literal: true

require 'slack-ruby-bot'
require 'sqlite3'

# Demonstrate the usage of the Model, View, and Controller
# classes to build an inventory bot.

SlackRubyBot::Client.logger.level = Logger::WARN

# The Controller takes the place of the `command` block. It has access to the
# `client`, `data`, and `match` arguments passed to the `command` block. Each
# instance method generates a route for the bot to match against.
#
# The controller instance accesses the model and view via the `model` and
# `view` accessor methods.
#
# ActiveSupport::Callbacks support is included so every method can have
# before, after, or around hooks.
#
# Helper methods should begin with an underscore (e.g. _row) so that
# `command` routes are not auto-generated for the method.
#
class InventoryController < SlackRubyBot::MVC::Controller::Base
  define_callbacks :react, :notify
  set_callback :react, :around, :around_reaction
  set_callback :notify, :after, :notify_admin
  attr_accessor :_row

  def create
    model.add_item(match[:expression])
  end

  def read
    run_callbacks :react do
      row = model.read_item(match[:expression])
      view.say(channel: data.channel, text: row.inspect)
    end
  end

  def update
    run_callbacks :notify do
      self._row = model.update_item(match[:expression])
    end
  end

  def delete
    result = model.delete_item(match[:expression])
    if result
      view.delete_succeeded
    else
      view.delete_failed
    end
  end

  private

  def notify_admin
    row = _row.first
    return if row[:quantity].to_i.zero?

    view.email_admin("Inventory item #{row[:name]} needs to be refilled.")
    view.say(channel: data.channel, text: "Administrator notified via email to refill #{row[:name]}.")
  end

  def around_reaction
    view.react_wait
    view.say(channel: data.channel, text: 'Please wait while long-running action completes...')
    sleep 2.0
    yield
    view.say(channel: data.channel, text: 'Action has completed!')
    view.unreact_wait
  end
end

# The Model contains all business logic.
#
# ActiveSupport::Callbacks support is included for before, after,
# or around hooks.
#
# The Model has access to the `client`, `data`, and `match` objects.
#
class InventoryModel < SlackRubyBot::MVC::Model::Base
  define_callbacks :fixup
  set_callback :fixup, :before, :normalize_data
  attr_accessor :_line

  def initialize
    @db = SQLite3::Database.new ':memory'
    @db.results_as_hash = true
    @db.execute 'CREATE TABLE IF NOT EXISTS Inventory(Id INTEGER PRIMARY KEY,
            Name TEXT, Quantity INT, Price INT)'

    s = @db.prepare 'SELECT * FROM Inventory'
    results = s.execute
    count = 0
    count += 1 while results.next
    return if count < 4

    add_item "'Audi',3,52642"
    add_item "'Mercedes',1,57127"
    add_item "'Skoda',5,9000"
    add_item "'Volvo',1,29000"
  end

  def add_item(line)
    self._line = line # make line accessible to callback
    run_callbacks :fixup do
      name, quantity, price = parse(_line)
      row = @db.prepare('SELECT MAX(Id) FROM Inventory').execute
      max_id = row.next_hash['MAX(Id)']
      @db.execute "INSERT INTO Inventory VALUES(#{max_id + 1},'#{name}',#{quantity.to_i},#{price.to_i})"
    end
  end

  def read_item(line)
    self._line = line
    run_callbacks :fixup do
      name, _other = parse(_line)
      statement = if name == '*'
                    @db.prepare 'SELECT * FROM Inventory'
                  else
                    @db.prepare("SELECT * FROM Inventory WHERE Name='#{name}'")
                  end

      results = statement.execute
      a = []
      results.each do |row|
        a << { id: row['Id'], name: row['Name'], quantity: row['Quantity'], price: row['Price'] }
      end
      a
    end
  end

  def update_item(line)
    self._line = line
    run_callbacks :fixup do
      name, quantity, price = parse(_line)
      statement = if price
                    @db.prepare "UPDATE Inventory SET Quantity=#{quantity}, Price=#{price} WHERE Name='#{name}'"
                  else
                    @db.prepare "UPDATE Inventory SET Quantity=#{quantity} WHERE Name='#{name}'"
                  end
      statement.execute
      read_item(_line)
    end
  end

  def delete_item(line)
    self._line = line
    run_callbacks :fixup do
      name, _other = parse(_line)
      before_count = row_count
      statement = @db.prepare "DELETE FROM Inventory WHERE Name='#{name}'"
      statement.execute
      before_count != row_count
    end
  end

  private

  def row_count
    statement = @db.prepare 'SELECT COUNT(*) FROM Inventory'
    result = statement.execute
    result.next_hash['COUNT(*)']
  end

  def parse(line)
    line.split(',')
  end

  def normalize_data
    name, quantity, price = parse(_line)
    self._line = [name.capitalize, quantity, price].join(',')
  end
end

# All interactivity logic should live in this class.
#
# ActiveSupport::Callbacks support is included for before, after,
# or around hooks.
#
# The Model has access to the `client`, `data`, and `match` objects.
#
class InventoryView < SlackRubyBot::MVC::View::Base
  def react_wait
    client.web_client.reactions_add(
      name: :hourglass_flowing_sand,
      channel: data.channel,
      timestamp: data.ts,
      as_user: true
    )
  end

  def unreact_wait
    client.web_client.reactions_remove(
      name: :hourglass_flowing_sand,
      channel: data.channel,
      timestamp: data.ts,
      as_user: true
    )
  end

  def email_admin(message)
    # send email to administrator with +message+
    # ...
    puts "Sent email to administrator: #{message}"
  end

  def delete_succeeded
    say(channel: data.channel, text: 'Item was successfully deleted.')
  end

  def delete_failed
    say(channel: data.channel, text: 'Item failed to be deleted.')
  end
end

class InventoryBot < SlackRubyBot::Bot
  help do
    title 'Inventory Bot'
    desc 'This bot lets you create, read, update, and delete items from an inventory.'

    command 'create' do
      desc 'Add an item to the inventory.'
    end

    command 'read' do
      desc 'Get inventory status for an item.'
    end

    command 'update' do
      desc 'Update inventory levels for an item.'
    end

    command 'delete' do
      desc 'Remove an item from inventory.'
    end
  end

  # Instantiate the Model, View, and Controller objects within the +Bot+ subclass
  # or within a SlackRubyBot::Commands::Base subclass.
  #
  model = InventoryModel.new
  view = InventoryView.new
  @controller = InventoryController.new(model, view)
  @controller.class.command_class.routes.each do |route|
    warn route.inspect
  end
end

InventoryBot.run
