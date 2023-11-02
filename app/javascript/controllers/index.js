// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import BroadcastChurpsController from "./broadcast_churps_controller"
application.register("broadcast-churps", BroadcastChurpsController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import ProfileModalController from "./profile_modal_controller"
application.register("profile-modal", ProfileModalController)

import ResetFormController from "./reset_form_controller"
application.register("reset-form", ResetFormController)

import ShowChurpController from "./show_churp_controller"
application.register("show-churp", ShowChurpController)

import ProfileFollowingController from "./profile_following_controller"
application.register("profile-following", ProfileFollowingController)

import ViewChurpsController from "./view_churps_controller"
application.register("view-churps", ViewChurpsController)
