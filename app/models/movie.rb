class Movie < ActiveRecord::Base
  
  # Reference https://stackoverflow.com/questions/181091/how-do-i-get-the-unique-elements-from-an-array-of-hashes-in-ruby
  def self.all_ratings
    # get the rattings from the database
    Movie.select(:rating).distinct.inject([]){|x, y| x.push y.rating}
  end
end
