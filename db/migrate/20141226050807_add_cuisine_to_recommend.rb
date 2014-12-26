class AddCuisineToRecommend < ActiveRecord::Migration
  def change
    add_attachment :recommends, :cuisine
  end
end
