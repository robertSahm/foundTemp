# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Drinkboard::Application.initialize!


# Cloudinary info here OR cloudinary.yml
CLOUDINARY_URL        = "cloudinary://524481758822216:BF2QigcKBvYJ8DCucCPqUsVcWvI@drinkboard"
CLOUDINARY_BASE_URL   = "http://res.cloudinary.com/drinkboard"
CLOUDINARY_SECURE_URL = "https://d3jpl91pxevbkh.cloudfront.net/drinkboard"
CLOUDINARY_UPLOAD     = "http://api.cloudinary.com/v1_1/drinkboard/image/upload"

# AWS S3 folder info
BUCKET    = 'drinkboard'
THUMB     = 'drinkboard/thumb'
PORTRAIT  = 'drinkboard/portrait'