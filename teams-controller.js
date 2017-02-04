/**
 * teams.js
 * 
 * Provides CRUD functionality to the Teams db collection
 */

var mongoose = require('mongoose');

var utilities = global.rootRequire('utilities');
var mongo_utilities = global.rootRequire('mongo_utilities');

var create = function(TeamModel) {
	return function(request, response) {
		
		console.log("teams-controller.js: create request body looks like: " + JSON.stringify(request.body));
		
		var newTeam = new TeamModel({name: request.body.name, age_group: request.body.age_group, year: request.body.year, 
			season: request.body.season, org_id: request.body.org_id});
		
		newTeam.save(function(error, data) {
			if (error) {
				console.log("error saving Teams doc to mongodb: " + JSON.stringify(error));
				mongo_utilities.sendMongoError(response, error);
			} else {
				console.log("saved Teams doc to mongodb" + JSON.stringify(data));
				utilities.sendJson(response, {id: data.id, name: data.name, age_group: data.age_group, year: data.year,
					season: data.season, org_id: data.org_id}, utilities.CREATED);
			}
		});
	};
};

/*
 * List all teams for an organization.
 */
var listOrgTeams = function(TeamModel) {
	return function(request, response) {
		
		console.log("teams-controller.js: listOrgTeams request body looks like: " + JSON.stringify(request.body));
		console.log("teams-controller.js: listOrgTeams request params look like: " + JSON.stringify(request.params));
		TeamModel.find({org_id: request.params.id}, function(error, data) {
			if (error) {
				console.log("teams-controller.js: error finding Teams docs in mongodb: " + JSON.stringify(error));
				mongo_utilities.sendMongoError(response, error);
			} else {
				console.log("teams-controller.js: found teams: " + JSON.stringify(data));
				utilities.sendJson(response, data, utilities.SUCCESS);
			}
		});
	};
};

module.exports.create = create;
module.exports.listOrgTeams = listOrgTeams;