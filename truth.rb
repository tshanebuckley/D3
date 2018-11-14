require 'sinatra'
require 'sinatra/reloader'

class String
	#string method to check if the string resembles an integer
    def is_i?
       self.to_i.to_s == self
    end
end

class Array
	#makes the array contain all binary strings of size n
	def bin_strings
		n = self.length
		(0..2**n - 1).map { |i| "%0#{n}b" % i }
	end
end

def truth_table (s)
	#intialize a table of size s
	table = Array.new(s)
	#fill table with all bit strings of size s
	table = table.bin_strings
	#split the bit strings into arrays with each element holding a 1 (true) or 0 (false)
	table = table.map {|x| x.split(%r{\s*})}
	#add values for AND, OR, and XOR
	x = table.length
	i = 0
	while i < x
		sum = table[i].sum {|x| x.to_i}
		#set AND
		if sum == s
			table[i].push("1")
		else
			table[i].push("0")
		end
		#set OR
		if sum > 0
			table[i].push("1")
		else
			table[i].push("0")
		end
		#set XOR
		if sum%2 == 0
			table[i].push("0")
		else
			table[i].push("1")
		end
		i = i + 1
	end
	#puts(table.to_s)
	return table
end

get '/' do
	erb :index
end

get '/display' do
	#set parameters
	tp = params['t_symbol']
	fp = params['f_symbol']
	sp = params['table_size']
	#empty submission cases
	if tp == ''
		tp = 'T'
	end
	if fp == ''
		fp = 'F'
	end
	if sp == ''
		sp = '3'
	end
	#check for correct submission
	if tp.length > 1 || fp.length > 1 || tp == fp || sp.to_i < 2 || sp.is_i? != true
	#1. chars are length of 1, 2. chars are not equal, 3. size >= 2, 4. size is an integer
		erb :invalid_entry
	else
		sp = sp.to_i
		table = truth_table sp
		erb :display, :locals => {tp: tp, fp: fp, sp: sp, table: table}
	end
end

not_found do
	status 404
	erb :page_not_found
end