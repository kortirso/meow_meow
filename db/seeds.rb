user = User.create(email: 'admin@example.com', password: 'password', admin: true)
pet = Pet.create(name: 'Simple pet', caption: 'Simple caption for pet', user: user)
Comment.create(body: 'Simple comment for simple pet from simple admin user', user: user)