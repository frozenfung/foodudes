# RAILS_ENV=production bin/rake db_fix:replacebr
namespace :db_fix do
  desc "change <br> to \n"
  task :replacebr => :environment do 
    Recommend.find_each do |r|
      r.content = r.content.gsub('\r\n', "\r\n")
      r.save!
    end
  end

  desc "initialize mobile_id"
  task :initialize_mobile_id => :environment do
    User.find_each do |u|
      u.mobile_id = SecureRandom.uuid if u.mobile_id == nil
      u.save!
    end
  end

  desc "fix precision of lag lng"
  task :precision => :environment do
    

  end
end


