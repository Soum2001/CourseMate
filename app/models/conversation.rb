class Conversation < ApplicationRecord
    belongs_to :student, class_name: "User", foreign_key: "user_id"
    TOPIC_MAP = {
        "python" => "Programming",
        "ruby" => "Programming",
        "javascript" => "Programming",
        "cloud" => "Cloud Computing",
        "aws" => "Cloud Computing",
        "docker" => "DevOps",
        "ml" => "Data Science",
        "machine learning" => "Data Science"
      }.freeze
end
