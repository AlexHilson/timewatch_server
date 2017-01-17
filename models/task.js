'use strict';
module.exports = function(sequelize, DataTypes) {
  var Task = sequelize.define('Task', {
    cost_code: {type: DataTypes.STRING, allowNull: false},
    analysis_code: {type: DataTypes.STRING, allowNull: false},
    hours_per_day: {type: DataTypes.STRING, allowNull: false}
  }, {
    classMethods: {
      associate: function(models) {
        // associations can be defined here
      }
    }
  });
  return Task;
};