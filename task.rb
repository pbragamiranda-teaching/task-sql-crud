require "pry-byebug"

class Task

  attr_reader :title, :id, :description
  attr_accessor :done

  def initialize(attr = {})
    @id = attr[:id]
    @title = attr[:title]
    @description = attr[:description]
    @done = attr[:done] || false
  end


  # delete
  def destroy
    DB.execute('DELETE FROM tasks WHERE id = ?', @id)
  end


  # read all
  def self.all
    results = DB.execute('SELECT * FROM tasks')
    tasks = results.map do |result|
      # binding.pry
      Task.new(id: result["id"],
             title: result["title"],
             description: result["description"],
             done: result[:done] == 1)
    end
  end


  # find by id
  def self.find(id)
    query = <<-SQL
      SELECT * FROM tasks
      WHERE id = ?
    SQL
    results = DB.execute(query, id).first
    Task.new(id: results["id"],
             title: results["title"],
             description: results["description"],
             done: results[:done] == 1) unless results.nil?
  end


  # create and update
  def save
    # check if record already exists or not
    if @id
      # update
      DB.execute(
        "UPDATE tasks SET title = ?, description = ?, done = ? WHERE = ?",
        @title, @description, @done ? 1 : 0, @id)
    else
    # create
      DB.execute(
        "INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)",
        @title, @description, @done ? 1 : 0)

      @id = DB.last_insert_row_id
    end
  end
end

# results = {"id"=>1,
#   "title"=>"Complete Livecode",
#   "description"=>"Implement CRUD on Task",
#   "done"=>0}

# Task.new(id: results["id"],
#          title: results["title"],
#          description: results["description"],
#          done: results[:done] == 1)
