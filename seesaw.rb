# require libaries
require 'csv'
require 'httparty'
require 'json'
 

username = 'testAPI'
password = 'testAPI'

api_url = 'platform1.greenseesaw.com/seesaw_api_test/_design/main/_view/allDocs'

endpoint = "http://#{username}:#{password}@#{api_url}"
response = HTTParty.get(endpoint) # make get request to endpoint
json_data = JSON.parse(response.body) # parse json data from response

# Set options for CSV processing
options = {   col_sep: ' | ', 
	      headers: true, 
	      row_sep: "\n\n",
	      :converters => lambda do |field|
             	   field.to_s.tr('"','')
              end
       	   }

# Open CSV file for writing
CSV.open("output.csv", "w", options) do |csv|

	# Set row headers for CSV file
	csv << ['id', 'rev', 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'SubObj.Qest', 'SubObj.Ans']

	# Loop through json data from api endpoint
	json_data['rows'].each do |data|

		# Cater for sub-objects
		subObjects = {}
		data['value'].each do |key, value|
			if key == 'SubObj'
				subObjects = value
			end
		end

		# write rows to CSV
		csv << [  data['value']['_id'], data['value']['_rev'], data['value']['col1'],
			  data['value']['col2'], data['value']['col3'], data['value']['col4'],
			  data['value']['col5'], data['value']['col6'], subObjects['a'], subObjects['b']
			]
	end
end
