class ClusteredCity
	def initialize(label, longitude, latitude, population)
		@label 			= label
		@longitude 		= longitude
		@latitude 		= latitude
		@population 	= population

		# Hash meant to hold cluster membership
		#    Example: {'12' => 3} implies for k=12 this City will belong to cluster ID'd # 3
		@clusterMembership = Hash.new
	end
	
	# For accessibility
	def longitude
		@longitude
	end
	def latitude
		@latitude
	end

	def addClusterMembership(k, clusterID)
		@clusterMembership[k.to_s] = clusterID
	end

	def hashOfInstanceVars()
		return {'label': @label, 'longitude': @longitude, 'latitude': @latitude, 
			'population': @population, 'clusterMembership': @clusterMembership  }
	end
	
	# Class method to write out a JSON file
	def self.writeHashToJSONFile(hashClusteredCities, fileName)
		# Assumed that hashClusteredCities is a colleciton of ClusteredCity objects
		
		# Convert from the objects to the hash.
		hashClusteredCities.each do |key, value|
			hashClusteredCities[key] = value.hashOfInstanceVars
		end
		
		puts "### Writing to file #{fileName}"
		File.open(fileName,"w") do |f|
			f.write(hashClusteredCities.to_json)
		end
	end
end