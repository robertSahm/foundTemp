class ServerCodeValidator < ActiveModel::Validator

	def validate(record)
		msg   =  "VALIDATE EACH record = #{record}"
		puts msg
		value = record.server_code
					# get all server codes from other servers at places where you work
					# 1. check to see if your are making it the same code you already had 
		record.providers.each do |p|
			codes = p.server_codes
			if codes.include? value 
				return record.errors[:server_code] << "that server code is taken , please try another"
			end
		end
	end	

end