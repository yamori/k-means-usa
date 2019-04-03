require 'json'

@jsonData = nil

File.open('data/USA_cities.json') do |f|
  @jsonData = JSON.parse(f.read)
  
  # This block automatically closes File.open
end


@jsonData.each do |obj|
	if obj['longitude'] > -125 # no Alaska or Hawaii please.
		puts obj['city']
	end
end

# darn: grep -irn springfield data/USA_cities.json