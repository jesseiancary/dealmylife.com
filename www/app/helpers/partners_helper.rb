module PartnersHelper
	
	def get_excerpt (string, count = 30)
		if string.length >= count
		  shortened = string[0, count]
			splitted = shortened.split(/\s/)
			words = splitted.length
			splitted[0, words-1].join(" ") + ' ...'
		else
			string
		end
	end
	
	def format_date date
	  date[5..6]+"/"+date[8..9]+"/"+date[0..3] if !date.nil? and date.length >= 10
	end
  
end