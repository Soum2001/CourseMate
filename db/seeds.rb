# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


## -----------------------------
# COURSE TITLES
# -----------------------------
course_titles = [
  "Beginner Ruby Programming",
  "Modern JavaScript Essentials",
  "Full-Stack Web Development",
  "Python for Absolute Beginners",
  "Mastering SQL & Databases",
  "Advanced HTML & CSS",
  "React.js Bootcamp",
  "API Development with Rails",
  "Intro to Cloud Computing",
  "Docker & DevOps Basics",
  "Machine Learning Foundation",
  "Data Analysis with Pandas",
  "GraphQL Crash Course",
  "Mobile App Development Basics",
  "UI/UX Design Principles",
  "TailwindCSS Deep Dive",
  "REST API Fundamentals",
  "Git & GitHub Masterclass",
  "Agile & Scrum for Developers",
  "Linux Command Line Essentials"
]


# -----------------------------
# CATEGORY + LEVEL MAPPERS
# -----------------------------
category_ids = {
  programming:  Category.find_by(name: "Programming").id,
  data_science: Category.find_by(name: "Data Science").id,
  cloud:        Category.find_by(name: "Cloud Computing").id,
  devops:       Category.find_by(name: "DevOps").id
}

level_ids = {
  beginner:     Level.find_by(name: "Beginner").id,
  intermediate: Level.find_by(name: "Intermediate").id,
  advanced:     Level.find_by(name: "Advanced").id
}


# -----------------------------
# CREATE COURSES
# -----------------------------
course_titles.each do |title|
  # Auto-assign category based on keywords
  category_id =
    case title
    when /Ruby|JavaScript|Web|HTML|CSS|React|Rails|GraphQL|Mobile|UI|UX|Tailwind|API/i
      category_ids[:programming]
    when /Machine Learning|Pandas|Data|Analysis/i
      category_ids[:data_science]
    when /Cloud/i
      category_ids[:cloud]
    when /Docker|DevOps|Linux|Git|Agile/i
      category_ids[:devops]
    else
      category_ids.values.sample
    end

  # Auto-assign level
  level_id =
    case title
    when /Beginner|Intro|Basics|Essentials/i
      level_ids[:beginner]
    when /Advanced|Deep|Masterclass/i
      level_ids[:advanced]
    else
      level_ids[:intermediate]
    end

  Course.create!(
    title: title,
    description: "A comprehensive course on #{title}. Learn step-by-step with practical projects.",
    amount: 1,
    instructor_id: [2, 3].sample,
    category_id: category_id,
    level_id: level_id
  )
end

# categories = [
#   { name: "Programming"},
#   { name: "Data Science"},
#   { name: "Cloud Computing"},
#   { name: "DevOps" }
# ]
# categories.each do |cat|
#   Category.find_or_create_by(name: cat[:name]) do |c|

#   end
# end

# levels = [
#   { name: "Beginner", rank: 1},
#   { name: "Intermediate", rank: 2 },
#   { name: "Advanced", rank: 3}
# ]
# levels.each do |lvl|
#   Level.find_or_create_by(name: lvl[:name]) do |l|
#     l.rank = lvl[:rank]
#   end
# end