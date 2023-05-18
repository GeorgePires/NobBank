# Hi!, use the rails dev:setup command to create data.

# Create Users
PASSWORD = 123_246
george = User.create!(first_name: "George", last_name: "Pires", email: "george@gmail.com", password: PASSWORD, password_confirmation: PASSWORD)
wes = User.create!(first_name: "Wes", last_name: "Pires", email: "wes@gmail.com", password: PASSWORD, password_confirmation: PASSWORD)

# Create Deposit and Withdraw
george_account = george.account
george_account.deposit(2000)
george_account.withdraw(200)

# Create transfer from George account to Wes account
wes_account = wes.account
george_account.transfer(1100, wes_account)
