//CloudantDBのview

//_design/events
//major
function (doc) {
  if(doc.type == 'event'){
    emit(doc.major, null);
  }
}


//_design/events
//event_info
function (doc) {
  if(doc.type == 'event'){
    var row = {
      event_name : doc.event_name,
      room_name : doc.room_name,
      description : doc.description,
      major : doc.major,
      items : doc.items
    };
    emit(doc.major, row);
  }
}

//_design/users
//Participants
function (doc) {
  if(doc.type == 'user'){
    var row = {
      id : doc._id,
      name : doc.name,
      image : doc.image,
      items : doc.items
    };
    emit(doc.major, row);
  }
}

//_design/users
//major
function (doc) {
  if(doc.type == 'user')
    emit(doc.major, 1);
}

//_design/users
//id
function (doc) {
  if(doc.type == 'user'){
    emit(doc._id, doc.major);
  }
}
//_design/users
//participants_count
function (doc) {
  if(doc.type == 'user'){
    emit(doc.major, 1);
  }
}
reduce sum
