require 'faker'

# Create the tables:

# DROP TABLE employees_projects;
# DROP TABLE projects;
# DROP TABLE employees;
# DROP TABLE departments;

# CREATE TABLE events (
#   id bigint NOT NULL,
#   user_id bigint NOT NULL,
#   event character varying NOT NULL,
#   created_at timestamp without time zone NOT NULL,
#   metadata jsonb
# );

# CREATE TABLE users (
#   id bigint NOT NULL,
#   created_at timestamp without time zone NOT NULL,
#   email character varying NOT NULL
# );


#  Insert some users into the users table
#
# The sql generated in users.sql will look like this:
# INSERT INTO users (id, created_at, email) VALUES
#   (1, '12/15/2020', 'random_person@email.com'),
#   (2, '12/16/2020', 'another_person@email.com');
used_emails = [nil]
users = []
0.upto(4999) do |i|
  id = i + 1
  created_at = Time.parse("01/12/2020") + (i/13) * 60 * 60 * 24
  email = Faker::Internet.email while used_emails.include?(email)
  used_emails << email
  users << [id, created_at, email]
end

File.open("users.sql", 'w') do |f|
  f.write("INSERT INTO users (id, created_at, email) VALUES\n")
  users[0..-2].each do |user|
    f.write("  (#{user[0]}, '#{user[1].strftime("%m/%d/%Y")}', '#{user[2]}'),\n")
  end
  f.write("  (#{users.last[0]}, '#{users.last[1].strftime("%m/%d/%Y")}', '#{users.last[2]}');")
end

#  Insert some events into the events table
#
# The sql generated in events.sql will look like this:
# INSERT INTO events (id, user_id, event, created_at, metadata) VALUES
#   (1, 1, 'view_landing', '12/15/2020', NULL),
#   (2, 1, 'create_trial', '12/16/2020', NULL),
#   (3, 1, 'engage_feature', '12/17/2020', '{"feature_name":"add_feature"}'),
#   (4, 1, 'convert', '12/18/2020', NULL);
events = ["view_landing", "create_trial", "engage_feature", "convert", "cancel"]

features = ["add_feature", "delete_feature", "edit_feature", "track_time",
  "create_graph", "create_document", "logout", "login_button",
  "time_management", "sprint_planning", "notes_editor", "diagrams"
]

File.open("events.sql", 'w') do |f|
  f.write("INSERT INTO events (id, user_id, event, created_at, metadata) VALUES\n")

  current_id = 1

  1.upto(5000) do |i|
    event_count = rand(10)
    created_at = Time.parse("01/12/2020") + (i/13) * 60 * 60 * 24
    0.upto(event_count) do |event|
      event_name = "engage_feature"
      if event < 2
        event_name = events[event]
      elsif event == event_count
        event_name = rand(20) > 15 ? "convert" : "cancel"
      end
      created_at += 60 * 60 * (rand(24)+1)
      metadata = "NULL"
      metadata = "'{\"feature_name\":\"#{features[rand(12)]}\"}'" if event_name == "engage_feature"
      f.write(" (#{current_id}, #{i}, '#{event_name}', '#{created_at.strftime("%m/%d/%Y")}', #{metadata}),\n")
      
      current_id += 1
    end
  end

end
File.truncate("events.sql", File.size("events.sql") - 2)
File.open("events.sql", 'a'){|f| f.write(";\n") }

# Problems

# 1. Create a funnel from these events. The funnel should show the total users for each event.
# We should be able to aggregate the funnel by any time period (day, month, year, etc).

# 2. Create a dataset for cohort analysis on the funnel. The marketing team would like to be able to select a month
# and see how the funnel performed with a cohort of users who were created during that month (not necessarily events that
# occured in that month).

# 3. Some of the events are duplicated. The "engage_feature" event is used to tell when a user engages with a feature
# and the "feature_name" will be placed in the "metadata" field. Filter the funnels you created to only include a single
# user for each engagement. (This may already be completed depending on how #1 was done).

# 4. Create a dataset to analyze which features were engaged with most by a particular cohort. The marketing team would
# like to select a month and see totals for engagement on each feature for the cohort who was created in that month
