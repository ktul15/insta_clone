const { v4: uuidv4 } = require('uuid');
const pool = require('../../config/databse');

const UserModel = {

  async getUserById(id) {
    const result = await pool.query('SELECT id, email FROM users WHERE id = $1', [id]);
    return result.rows[0];
  },
  
  async getAllUsers() {
    const result = await pool.query('SELECT * FROM users');
    return result.rows;
  },

  async createUser(email, username, password) {
    const id = uuidv4();
    const result = await pool.query(
      'INSERT INTO users (id, email, password, username) VALUES ($1, $2, $3, $4) RETURNING *',
      [id, email, password, username]
    );
    return result.rows[0];
  },

  async getUserByEmail(email) {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0];
  },

  async getUserByUsername(username) {
    const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
    return result.rows[0];
  },
};

module.exports = UserModel;