require "sqlite3"
DB = SQLite3::Database.new("tasks.db")
DB.results_as_hash = true
require_relative "task"

# CREATE
run_2k = Task.new(title: "run 2k",
                  description: "really run 2k")
p run_2k.id
run_2k.save
p run_2k.id

# UPDATE
p run_2k.done
run_2k.done = true
p run_2k.done

# READ
# -read one task
task1 = Task.find(1)
p task1

# -read all tasks
Task.all.each do |task|
  puts "#{task.title} - #{task.description}"
end

# DELETE
task1 = Task.find(4)
task1.destroy

