# README

PreRequisites

### Ruby version:  3.4.2 
  - Rails 8.0.1
  - PostgreSQL
  - `curl` (for testing POST requests)
  - `git` (for cloning the repository)
  
### Clone repository 

   ```
   gh repo clone pbressan13/blog
   cd ratings-app
   ```

###  Install dependencies
    bundle install
    
###  Database creation
    rails db:create

###  Run migrations:
    rails db:migrate
    
### Seed the database (optional):
    rails db:seed
    # If you don't have too much time, please change the posts_count db/seeds.rb:L:16 for a smaller number
###  Running the Application
    rails server
    
By default, the application will be accessible at http://localhost:3000.

## Testing the Endpoints

1. To fetch the top posts, open your browser and navigate to: http://localhost:3000/posts/top?max=5,   This will return the top 5 posts ordered by average rating.
2. To get the list of repeated IP addresses, navigate to: http://localhost:3000/posts/repeated_ips This will return a list of the same ips that were used by different users
3. To create a post, use curl from the command line in a terminal. Replace **POST_TITLE**, **POST_BODY**, and **USER_LOGIN** with your data.
  ```
  curl -X POST http://localhost:3000/posts \
  -d '{"post": {"title": "POST_TITLE", "body": "POST_BODY", "ip": "192.168.0.1"}, "user": {"login": "USER_LOGIN"}}' \
  -H "Content-Type: application/json"
  ```
4. To create a rating for a post, use curl. Replace **POST_ID**, **USER_ID**, and **RATING_VALUE** with your values, post_id and user_id corresponds to the ids from the tables, RATING_VALUE is from 1..5 values
  
  ```
curl -X POST http://localhost:3000/ratings \
  -d '{"post_id": POST_ID, "user_id": USER_ID, "value": RATING_VALUE}' \
  -H "Content-Type: application/json"
  ```


## Development Notes
 ### Controller Actions
   - RatingsController#create: Creates a new rating for a post, ensuring each user can only rate a post once.
   - PostsController#create: Creates a new post with an associated user.
   - PostsController#top: Fetches the top-rated posts, ordered by their average rating.
   - PostsController#repeated_ips: Fetches the IP addresses used by more than one user.
### Database Structure
The application uses a PostgreSQL database (or your preferred database) with the following tables:
   - users – Stores the login information for users.
   - posts – Stores the posts with titles, bodies, and IP addresses.
   - ratings – Stores ratings for each post, with values between 1 and 5.

### How to run the test suite

* ```rspec```


