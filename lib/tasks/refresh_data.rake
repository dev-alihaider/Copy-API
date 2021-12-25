namespace :refresh_data do

  desc "Fetch data from airtable and store in copy.json file"
  task copy: :environment do

    client = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
    table = client.table(ENV['AIRTABLE_APP_ID'], "Copy")

    records = table.records

    file = File.read('./copy.json')
    file_data = JSON.parse(file).with_indifferent_access

    data_hash = parse_row file_data, records, ActiveSupport::HashWithIndifferentAccess.new

    while records.offset.present?
      records = table.records(:offset => records.offset)
      data_hash = parse_row file_data, records, data_hash
    end

    File.write('./copy.json', JSON.dump(data_hash))

    $file_data = data_hash
  end

  def parse_row file_data, records, data_hash
    records.each do |row|
      if !file_data[row[:key]].present? || (file_data[row[:key]].present? && row[:copy] != file_data[row[:key]][:copy])
        updated_at = DateTime.now.to_i
      else
        updated_at = file_data[row[:key]][:updated_at]
      end
      data_hash[row[:key]] = { copy: row[:copy], updated_at: updated_at }
    end

    data_hash
  end
end
