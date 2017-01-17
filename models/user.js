'use strict';
module.exports = function(sequelize, DataTypes) {
  var User = sequelize.define('User', {
    username: {type: DataTypes.STRING, allowNull: false, unique: true}
  }, {
    classMethods: {
      associate: function(models) {
        User.hasMany(models.Task);
        User.hasOne(models.Timewatch);
      }
    }
  });
  return User;
};