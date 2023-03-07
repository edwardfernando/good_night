# Good Night App


This is a Rails 7 application that lets users track when they go to bed and when they wake up. It provides RESTful APIs for users to perform operations such as clocking in, following and unfollowing other users, and seeing sleep records of their friends over the past week.

## Prerequisites

To run this application, you need to have the following software installed:

    Ruby version 3.2.1
    Rails version 7.0.4
    Docker and Docker Compose

## Installation

1. Clone this repository to your local machine.
2. Run `docker-compose up` to start the PostgreSQL database.
3. Run `rails db:create` to create the required database.
4. Run `rails db:seed` to create sample user and following relationship. There are currently 3 users provided. You can add more with the provided endpoint.
5. Run `rails db:migrate` to run the database migrations.
6. Run `rails s` to start the Rails server.

## Usage

### Register New User

Users can register a new user by making a POST request to the `/api/v1/users` endpoint. This endpoint accepts a json body that has `name` as part of required body:

```angular2html
{ "name": "my new name" }
```

#### POST Sample Response - success

    {
        "status": "created",
        "message": "success",
        "data": {
            "id": 21,
            "name": "my new name",
            "created_at": "2023-03-07T13:22:12.411Z",
            "updated_at": "2023-03-07T13:22:12.411Z"
        },
        "errors": null
    }

#### POST Sample Response - name blank

    {
        "status": "unprocessable_entity",
        "message": "fail",
        "data": null,
        "errors": [
            "Name can't be blank"
        ]
    }

#### POST Sample Response - required parameter

    {
        "status": "bad_request",
        "message": "fail",
        "data": null,
        "errors": "param is missing or the value is empty: user"
    }

### Clock In operation `/api/v1/users/:user_id/clock_ins`

Users can clock in by making a POST request to the  `/api/v1/users/:user_id/clock_ins` endpoint. The `user_id` parameter specifies the ID of the user who is clocking in. This will clock the user in at the current time. 

To get all clocked-in times, ordered by created time, users can make a GET request to the same endpoint.

To clock ou, users can make a DELETE request to the same endpoint.

#### POST Sample Response - success

    {
        "status": "ok",
        "message": "clocked in successfully",
        "data": [
            {
                "id": 1,
                "user_id": 1,
                "clock_in": "2023-03-05T23:50:03.463Z",
                "clock_out": "2023-03-05T23:59:31.110Z",
                "duration": 567.64633,
                "created_at": "2023-03-05T23:50:03.461Z",
                "updated_at": "2023-03-05T23:59:31.110Z"
            }
        ],
        "errors": null
    }

#### POST Sample Response - with latest clock in that has not been clocked out

    {
        "status": "bad_request",
        "message": "you need to clock out first",
        "data": null,
        "errors": null
    }

#### GET Sample Response

    {
        "status": "ok",
        "message": "success",
        "data": [
            {
                "id": 1,
                "user_id": 1,
                "clock_in": "2023-03-05T23:50:03.463Z",
                "clock_out": "2023-03-05T23:59:31.110Z",
                "duration": 567.64633,
                "created_at": "2023-03-05T23:50:03.461Z",
                "updated_at": "2023-03-05T23:59:31.110Z"
            }
        ],
        "errors": null
    }

#### DELETE Clock out Sample Response

    {
        "status": "ok",
        "message": "clocked out successfully",
        "data": null,
        "errors": null
    }

### Following and unfollowing other users

Users can follow and unfollow other users by making POST requests to the `/api/v1/users/:user_id/users/:id/follow` and `/api/v1/users/:user_id/users/:id/unfollow` endpoints, respectively. 

The `user_id` parameter specifies the ID of the user who is following or unfollowing, and the `id` parameter specifies the ID of the user who is being followed or unfollowed.

#### POST Follow Sample Response - `/api/v1/users/:user_id/users/:id/follow`

    {
        "status": "ok",
        "message": "successfully following regina",
        "data": null,
        "errors": null
    }

#### POST Unfollow Sample Response - `/api/v1/users/:user_id/users/:id/unfollow`

    {
        "status": "ok",
        "message": "successfully unfollowing regina",
        "data": null,
        "errors": null
    }

### Seeing sleep records of friends over the past week

To see the sleep records of friends over the past week, ordered by the length of their sleep, users can make a `GET` request to the `/api/v1/users/:user_id/users/:id/sleep_records` endpoint. 

The `user_id` parameter specifies the ID of the user who is making the request, and the `id` parameter specifies the ID of the friend whose sleep records are being requested.

#### Sleep Record Sample Response 

    {
        "status": "ok",
        "message": "regina",
        "data": [
            {
                "id": 3,
                "user_id": 2,
                "clock_in": "2023-03-06T02:17:29.234Z",
                "clock_out": "2023-03-06T02:18:32.895Z",
                "duration": 63.661192,
                "created_at": "2023-03-06T02:17:29.233Z",
                "updated_at": "2023-03-06T02:18:32.895Z"
            },
            {
                "id": 4,
                "user_id": 2,
                "clock_in": "2023-03-06T02:18:40.925Z",
                "clock_out": "2023-03-06T02:18:43.890Z",
                "duration": 2.965918,
                "created_at": "2023-03-06T02:18:40.923Z",
                "updated_at": "2023-03-06T02:18:43.891Z"
            }
        ],
        "errors": null
    }

#### Sleep Record - Not following Sample Response

    {
        "status": "bad_request",
        "message": "you need to follow edward to see the sleep records",
        "data": null,
        "errors": null
    }