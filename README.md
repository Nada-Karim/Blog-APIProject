# Blog API Application 

Welcome to my GitHub repository!

## Description

This project is a Blog Application API created with Ruby on Rails. It provides a RESTful API for managing blog posts and user authentication. The application uses PostgreSQL for the database, Sidekiq and Redis for scheduling post deletions, and JWT for API authentication. The project includes a `docker-compose` setup to run the entire stack easily.

## Features

- **User Authentication**
- **Post Management**

## Getting Started

### Prerequisites

- Docker and Docker Compose installed and running

### Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name

2. **Set up your .env file:**
   ```bash
    POSTGRES_DB=blog_api_project
    POSTGRES_USER={your_user_name}
    POSTGRES_PASSWORD={your_password}
    POSTGRES_HOST=db
    POSTGRES_PORT=5432


3. **Build and start the application:**
   ```bash
    docker-compose up --build

# Usage
## Authentication
Before accessing any endpoints related to posts, you must sign up or log in to receive a JWT token. This token must be included in the Authorization header as a Bearer token for all subsequent requests to the API.

## Signup
### Happy scenario
  - **Endpoint:** POST /signup
  - **Request Body:**
    ```bash:
    { 
        "user":{
        "name": "name",
        "email": "name@example.com",
        "password": "password123",
        "image": "http://example.com/image.jpg"
        }
    }
  - **Response:**
    ```bash:
      { "token": "your_jwt_token"}
  - Note
    Include it in the Authorization header of your requests with the format: Bearer your_jwt_token

### UnHappy scenario one: Invalid email
  - **Endpoint:** POST /signup
  - **Request Body:**
    ```bash:
    { 
        "user":{
        "name": "name",
        "email": "@example.com",
        "password": "password123",
        "image": "http://example.com/image.jpg"
        }
    }
  - Response
    ```bash:
     {
        "errors": [
            "Email is invalid"
        ]
    }
### UnHappy scenario two: Short password
  - **Endpoint:** POST /signup
  - **Request Body:**
    ```bash:
    { 
        "user":{
        "name": "name",
        "email": "name@example.com",
        "password": "pass",
        "image": "http://example.com/image.jpg"
        }
    }
  - **Response:**
    ```bash:
     {
        "errors": [
            "Password is too short (minimum is 6 characters)"
        ]
    }
### UnHappy scenario three: no password
  - **Endpoint:** POST /signup
  - **Request Body:**
    ```bash:
    { 
        "user":{
        "name": "name",
        "email": "name@example.com",
        "password": "",
        "image": "http://example.com/image.jpg"
        }
    }
  - **Response:**
    ```bash:
     {
        "errors": [
            "Password can't be blank"
        ]
    }
### UnHappy scenario three: Already has an account
  - **Endpoint:** POST /signup
  - **Request Body:**
    ```bash:
    { 
        "user":{
        "name": "name",
        "email": "name@example.com",
        "password": "password123",
        "image": "http://example.com/image.jpg"
        }
    }
  - **Response:**
    ```bash:
     {
        "errors": [
            "Email has already been taken"
        ]
    }
    
## Login
### Happy scenario 
  - **Endpoint:** POST /login
  - **Request Body:**
    ```bash:
      {
          "email": "john@example.com",
          "password": "password123"
      }

  - **Response:**
    ```bash:
      { "token": "your_jwt_token"}
  - Note
    Include it in the Authorization header of your requests with the format: Bearer your_jwt_token

### UnHappy scenario: Invalid credentials
  - **Endpoint:** POST /login
  - **Request Body:**
    ```bash:
      {
          "email": "nameOne@example.com",
          "password": "password123"
      }

  - **Response:**
    ```bash:
      {
          "error": [
              "User_authentication invalid credentials"
          ]
      }

## Posts
## Create a Post
### Happy scenario
  - **Endpoint:** POST /posts (with authentication token)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Post title",
          "body": "Post body content"
        },
        "tags": ["tag1","tag2"]
      }
  - **Response:**
    ```bash
      {
      "message": "Post created successfully"
      }
### UnHappy scenario one: An unauthorized user
  - **Endpoint:** POST /posts (without authentication token)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Post title",
          "body": "Post body content"
        },
        "tags": ["tag1","tag2"]
      }
  - **Response:**
    ```bash
      {
        "error": "Not Authorized"
      }
### UnHappy scenario two: Tags are empty
  - **Endpoint**: POST /posts (without authentication token)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Post title",
          "body": "Post body content"
        },
        "tags": 
      }
  - **Response:**
    ```bash
      {
        "error": "At least one tag is required"
      }
    
## Read Posts
  - **Endpoint:** GET /posts (with authentication token)
  - **Response:**
    ```bash
          [
              {
                "id": 24,
                "title": "PostOne title",
                "body": "PostOne body",
                "user_id": 3,
                "created_at": "2024-08-16T19:27:20.320Z",
                "updated_at": "2024-08-16T19:27:20.320Z",
                "tags": [
                    {
                        "id": 2,
                        "name": "tag1",
                        "created_at": "2024-08-16T19:14:41.836Z",
                        "updated_at": "2024-08-16T19:14:41.836Z"
                    },
                    {
                        "id": 3,
                        "name": "tag2",
                        "created_at": "2024-08-16T19:14:41.858Z",
                        "updated_at": "2024-08-16T19:14:41.858Z"
                    }
                ]
            },
            {
                "id": 25,
                "title": "PostTwo title",
                "body": "PostTwo body",
                "user_id": 3,
                "created_at": "2024-08-16T19:27:45.421Z",
                "updated_at": "2024-08-16T19:27:45.421Z",
                "tags": [
                    {
                        "id": 3,
                        "name": "tag2",
                        "created_at": "2024-08-16T19:14:41.858Z",
                        "updated_at": "2024-08-16T19:14:41.858Z"
                    }
                ]
                   "comments": [
                      {
                          "id": 1,
                          "body": "comment one on post two",
                          "user_id": 3,
                          "post_id": 25,
                          "created_at": "2024-08-16T20:09:03.385Z",
                          "updated_at": "2024-08-16T20:09:03.385Z",
                          "user": {
                              "id": 3,
                              "email": "john@example.com",
                              "created_at": "2024-08-16T17:20:51.918Z",
                              "updated_at": "2024-08-16T17:20:51.918Z",
                              "name": "name",
                              "image": "http://example.com/image.jpg"
                          }
                ]
       },
            },
            {
                "id": 26,
                "title": "PostThree title",
                "body": "PostThree body",
                "user_id": 3,
                "created_at": "2024-08-16T19:28:17.456Z",
                "updated_at": "2024-08-16T19:28:17.456Z",
                "tags": [
                    {
                        "id": 4,
                        "name": "tag3",
                        "created_at": "2024-08-16T19:28:17.475Z",
                        "updated_at": "2024-08-16T19:28:17.475Z"
                    },
                    {
                        "id": 2,
                        "name": "tag1",
                        "created_at": "2024-08-16T19:14:41.836Z",
                        "updated_at": "2024-08-16T19:14:41.836Z"
                    }
                ]
            }
        ]
  


## Read a Post
  - **Endpoint:** GET /posts/:id (with authentication token)
  - **Response:**
    ```bash
      {
          "id": 25,
          "title": "PostTwo title",
          "body": "PostTwo body",
          "user_id": 3,
          "created_at": "2024-08-16T19:27:45.421Z",
          "updated_at": "2024-08-16T19:27:45.421Z",
          "tags": [
              {
                  "id": 3,
                  "name": "tag2",
                  "created_at": "2024-08-16T19:14:41.858Z",
                  "updated_at": "2024-08-16T19:14:41.858Z"
              }
          ]
           "comments": [
              {
                  "id": 1,
                  "body": "comment one on post two",
                  "user_id": 3,
                  "post_id": 25,
                  "created_at": "2024-08-16T20:09:03.385Z",
                  "updated_at": "2024-08-16T20:09:03.385Z",
                  "user": {
                      "id": 3,
                      "email": "john@example.com",
                      "created_at": "2024-08-16T17:20:51.918Z",
                      "updated_at": "2024-08-16T17:20:51.918Z",
                      "name": "name",
                      "image": "http://example.com/image.jpg"
                  }
              }
          ]
      }

## Update a Post
### Happy scenario
  - **Endpoint:** PUT /posts/:id (with the authentication token of the post author)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Updated Post Title",
          "body": "Updated post body content"
        },
        "tags": ["updatedtag1"]
      }
  - **Response:**
    ```bash
        {
        "message": "Post updated successfully"
        }

### Unhappy scenario one: Not the author
  - **Endpoint:** PUT /posts/:id (with the authentication token of a user but, not the author)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Updated Post Title",
          "body": "Updated post body content"
        },
        "tags": ["updatedtag1"]
      }
  - **Response:**
    ```bash
      {
          "error": "Not Authorized"
      }
### Unhappy scenario two: No tags
  - **Endpoint:** PUT /posts/:id (with the authentication token of the user that posted the post)
  - **Request Body:**
    ```bash
      {
        "post": {
          "title": "Updated Post Title",
          "body": "Updated post body content"
        },
        "tags": 
      }
  - **Response:**
    ```bash
    {
        "error": "At least one tag is required"
    }

## Delete a Post
### Happy scenario
    - **Endpoint:** DELETE posts/:id (with the authentication token of the post author)
    - **Response:**
      ```bash
        {
          "message": "Post deleted successfully"
        }
### Unhappy scenario one: Not the author
  - **Endpoint:** DELETE posts/:id  ( with the authentication token of a user but, not the author )
  - **Response:**
    ```bash
      {
          "error": "Not Authorized"
      }




## Comments
## Read Comments 
  - **Endpoint:** GET `/posts/:post_id/comments` (with authentication token)
  - **Response:**
    ```bash
    [
      {
          "id": 12,
          "body": "This is a comment",
          "user_id": 3,
          "post_id": 25,
          "created_at": "2024-08-16T19:27:45.421Z",
          "updated_at": "2024-08-16T19:27:45.421Z"
      }
    ]
    ```


## Read a Comment
  - **Endpoint:** GET `/posts/:post_id/comments/:id` (with authentication token)
  - **Response:**
    ```bash
      {
          "id": 12,
          "body": "This is a comment",
          "user_id": 3,
          "post_id": 25,
          "created_at": "2024-08-16T19:27:45.421Z",
          "updated_at": "2024-08-16T19:27:45.421Z"
      }
    ```
  

## Create a Comment
#### Happy scenario
  - **Endpoint:** POST `/posts/:post_id/comments` (with authentication token)
  - **Request Body:**
    ```bash
      {
        "comment": {
          "body": "This is a new comment"
        }
      }
    ```
  - **Response:**
    ```bash
      {
        "message": "Comment created successfully"
      }
    ```

### Unhappy scenario one: Empty comment body
  - **Endpoint:** POST `/posts/:post_id/comments` (with authentication token)
  - **Request Body:**
    ```bash
      {
        "comment": {
          "body": ""
        }
      }
    ```
  - **Response:**
    ```bash
      {
        "body": [
          "can't be blank"
      ]
      }
    ```
  

## Update a Comment
### Happy scenario
  - **Endpoint:** PUT `/posts/:post_id/comments/:id` (with the authentication token of the comment author)
  - **Request Body:**
    ```bash
      {
        "comment": {
          "body": "Updated comment content"
        }
      }
    ```
  - **Response:**
    ```bash
      {
        "message": "Comment updated successfully"
      }
    ```

### Unhappy scenario one: Not the author
  - **Endpoint:** PUT `/posts/:post_id/comments/:id` (with the authentication token of a user but not the comment author)
  - **Request Body:**
    ```bash
      {
        "comment": {
          "body": "Updated comment content"
        }
      }
    ```
  - **Response:**
    ```bash
      {
        "error": "Not Authorized"
      }
    ```

### Unhappy scenario two: Empty comment body
  - **Endpoint:** PUT `/posts/:post_id/comments/:id` (with the authentication token of the comment author)
  - **Request Body:**
    ```bash
      {
        "comment": {
          "body": ""
        }
      }
    ```
  - **Response:**
    ```bash
      {
        "error": "Comment body cannot be empty"
      }
    ```
  
  ---

## Delete a Comment
### Happy scenario
  - **Endpoint:** DELETE `/posts/:post_id/comments/:id` (with the authentication token of the comment author)
  - **Response:**
    ```bash
      {
        "message": "Comment deleted successfully"
      }
    ```

### Unhappy scenario one: Not the author
  - **Endpoint:** DELETE `/posts/:post_id/comments/:id` (with the authentication token of a user but not the comment author)
  - **Response:**
    ```bash
      {
        "error": "Not Authorized"
      }
    ```
