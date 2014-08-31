angular = require 'angular'

angular.module('app').controller 'HeaderCtrl', ($scope, User, $state, $rootScope, Auth, Token) ->
  User.get().$promise.then (user) ->
    $scope.user = user

  $scope.title = $state.current.data.title

  $rootScope.$on 'titleChanged', (event, title) ->
    $scope.title = title

  $rootScope.$on 'userUpdated', (event, user) ->
    $scope.user = angular.copy user

  $scope.logout = ->
    Token.delete().$promise.then ->
      Auth.destroy()
      $state.go 'login'