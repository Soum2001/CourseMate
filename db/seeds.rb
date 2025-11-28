# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


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

20.times do |i|
  Course.create!(
    title: course_titles[i],
    description: "A comprehensive course on #{course_titles[i]}. Learn step-by-step with practical projects.",
    amount: 1,
    instructor_id: [2, 3].sample
  )
end
