module ApplicationHelper
  
  def recommend_by_myself(recommends)
    result = '.recommend'

    recommends.each do |recommend|
      if recommend.user == current_user
        result = '.recommend_already' 
      end
    end

    result
  end

end
