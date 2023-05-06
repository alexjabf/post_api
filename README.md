# README

## Getting Started

To get started with this project, you will need to clone the repository to your local machine and then install the required dependencies using Bundler. You will also need to configure your environment variables and set up your database.

### Prerequisites

Before you can run this application, you will need to have the following installed on your machine:

- Ruby version 3.2.2
- Ruby on Rails version 7.0.4.3
- PostgreSQL version 9.6 or later

### Installing

To install this application, follow these steps:

1. Clone the repository to your local machine using the following command:

   ```
   git clone git@github.com:alexjabf/post_api.git
   ```

2. Change into the project directory using `cd repo-name`.

3. Install the required gems by running the following command:

   ```
   bundle install
   ```

4. Configure your environment variables by creating a `.env` file in the project root directory and adding the necessary variables. Refer to the `.env.example` file for a list of required variables.

5. Set up your database by running the following commands:

   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

## Running the Tests

This project uses RSpec for testing. To run the tests, use the following command:

```
bundle exec rspec
```

## API Endpoints

This project includes the following API endpoints:

- `GET /api/v1/posts` - Get a list of all posts
- `GET /api/v1/posts/:id` - Get a specific post by ID
- `POST /api/v1/posts` - Create a new post
- `PUT /api/v1/posts/:id` - Update an existing post
- `DELETE /api/v1/posts/:id` - Delete a post by ID
- `GET /api/v1/comments` - Get a list of all comments (you can filter by post_id)
- `GET /api/v1/comments/:id` - Get a specific comment by ID
- `POST /api/v1/comments` - Create a new comment
- `PUT /api/v1/comments/:id` - Update an existing comment
- `DELETE /api/v1/comments/:id` - Delete a comment by ID

For create, update and delete actions, you will need to send the request with basic authentication. 
The username and password are stored in the `ENV` variables `API_USERNAME` and `API_PASSWORD` respectively.
The username and password are stored in the `ENV` variables `API_USERNAME` and `API_PASSWORD` respectively.

For index action, you can send the request without authentication. You can also send the request with 
pagination parameters `page` and `per_page` to paginate the results. In addition, you can send the request with
sorting parameters to sort the results. The available sorting parameters are `order_by` which can be set to `author` or 
`content`, `created_at`, etc., and `order` which can be set to `asc` or `desc`.

For more detailed information on the available endpoints and their expected parameters, please refer to the API documentation.
```
https://documenter.getpostman.com/view/10771557/2s93eX1YZS
```
## Deployment

This project can be deployed to any hosting platform that supports Ruby on Rails applications. Some popular options include Heroku, AWS, and DigitalOcean.

## Built With

- Ruby on Rails - The web framework used
- PostgreSQL - The database management system used
- RSpec - The testing framework used

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request. All contributions are welcome!

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.