'use strict';
module.exports = function(sequelize, DataTypes) {
  var Timewatch = sequelize.define('Timewatch', {
    email: {type: DataTypes.STRING, allowNull: false},
    password: {type: DataTypes.STRING, allowNull: false}
  }, {
    classMethods: {
      associate: function(models) {
        Timewatch.belongsTo(models.User)
      }
    }
  });
  return Timewatch;
};