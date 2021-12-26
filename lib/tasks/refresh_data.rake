namespace :refresh_data do

  desc "Fetch data from airtable and store in copy.json file"
  task copy: :environment do
    Copy.new.refresh
  end

end
