db = (require __dirname+'/utils/db').db
cfg = (require __dirname+'/../config').cfg

Schema = db.Schema
ObjectId = Schema.ObjectId

AuthorizedUser = new Schema({
  name: String
  date: { type: Date, default: Date.now }
})

db.model('AuthorizedUser', AuthorizedUser)
AuthorizedUserModel = db.model('AuthorizedUser')

addAuthorized = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command is 'auth'
      if from is cfg.owner
        name = message.split(/\s+/).filter((x) -> return x)[0]
        AuthorizedUserModel.findOne {name: name}, (err, usr) ->
          if usr
            console.log "Authorized User #{usr.name} was already authorized."
          else
            console.log "Authorizing #{name}"
            usr = new AuthorizedUserModel()
            usr.name = name
            usr.save (err)->
              if err
                console.log "Error adding authorized user!"
                console.log err
        
}

removeAuthorized = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command is 'deauth'
      if from is cfg.owner
        name = message.split(/\s+/).filter((x) -> return x)[0]
        AuthorizedUserModel.findOne {name: name}, (err, usr) ->
          if usr
            usr.remove()
            console.log "Deauthorized User #{usr.name}."
          else
            console.log "#{name} is not an authorized user"
}

exports.events = [addAuthorized, removeAuthorized]
