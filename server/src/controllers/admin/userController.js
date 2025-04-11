const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const UserModel = require('../../models/admin/userModel');

const UserController = {
  async getUserDetails(req, res) {
    try {
      const token = req.headers.authorization?.split(' ')[1]

      if(!token){
        return res.status(401).json({error: "Authorization failed."})
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET)

      const user = await UserModel.getUserById(decoded.id)

      if(!user){
        return res.status(404).json({error: "User not found"})
      }

      const {id, email} = user;
      res.status(200).json({id, email})
    } catch(err){
      console.error(`err: ${err}`)
      res.status(401).json({error: "Invalid token"})
    }
  },
  
  async login(req, res) {
    try {
        if(req.body == undefined){
            return res.status(400).json({ error: 'Email and password are required' });
        }
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
      }

      // Check if the user exists
      const user = await UserModel.getUserByEmail(email);

      if (user) {
        // If user exists, validate the password
        console.log("user found")
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
          return res.status(401).json({ error: 'Invalid email or password' });
        }

        // Generate a JWT token
        const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
          expiresIn: '1h',
        });

        return res.status(200).json({ message: 'Sign-in successful', token, user });
      } else {
        // If user does not exist, create a new user
        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await UserModel.createUser(email, hashedPassword);

        // Generate a JWT token for the new user
        const token = jwt.sign({ id: newUser.id, email: newUser.email }, process.env.JWT_SECRET, {
          expiresIn: '1h',
        });

        return res.status(201).json({ message: 'Account created successfully', token, user: newUser });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to process request' });
    }
  },
};

module.exports = UserController;