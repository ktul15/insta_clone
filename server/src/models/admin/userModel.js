const { v4: uuidv4 } = require('uuid');
const pool = require('../../config/databse');

const UserModel = {

  async getUserById(id) {
    const result = await pool.query('SELECT id, email FROM admin_users WHERE id = $1', [id]);
    return result.rows[0];
  },
  
  async getAllUsers() {
    const result = await pool.query('SELECT * FROM admin_users');
    return result.rows;
  },

  async createUser(email, password) {
    const id = uuidv4();
    const result = await pool.query(
      'INSERT INTO admin_users (id, email, password) VALUES ($1, $2, $3) RETURNING *',
      [id, email, password]
    );
    return result.rows[0];
  },

  async getUserByEmail(email) {
    const result = await pool.query('SELECT * FROM admin_users WHERE email = $1', [email]);
    return result.rows[0];
  },
};

module.exports = UserModel;