module ApplicationHelper

  def recommend_by_myself(recommends)
    result = '.recommend'

    recommends.each do |recommend|
      if current_user.friends.include?(recommend.user)
        result = '.recommend_already' if recommend.user == current_user
      end
    end

    result
  end

end
