# app.rb
require 'rubygems'
require 'sinatra'
require 'thin'
require 'liquid'
require './pdf-filler.rb'

#return a filled PDF as a result of post data
post '/fill' do
  pdf = Pdf_Filler.new
  send_file pdf.fill( params['pdf'], params ).path
end

#return JSON list of field names
#e.g., /fields.json?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.json' do
  pdf = Pdf_Filler.new
  pdf.get_fields( params['pdf'] ).to_json
end

#get an HTML listing of all the fields
#e.g., /fields.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/fields.html' do
  pdf = Pdf_Filler.new
  liquid :fields, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }
end

#get an HTML representation of the form
#e.g., /form.html?pdf=http://help.adobe.com/en_US/Acrobat/9.0/Samples/interactiveform_enabled.pdf
get '/form.html' do
  pdf = Pdf_Filler.new
  liquid :form, :locals => { :pdf => params['pdf'], :fields => pdf.get_fields( params['pdf'] ) }
end

# documentation
get '/' do 
  markdown :index
end