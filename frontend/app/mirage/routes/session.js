export default function() {
  this.get('session', function(db) {
    const currentUser = db.users.firstOrCreate({
      email: 'current-user@example.com'
    });
    return {
      data: {
        id: currentUser.id,
        type: 'user',
        attributes: {
          name: currentUser.name,
          email: currentUser.email
        }
      }
    };
  });

  this.post('session', function() {
    return {
      auth_token: 'abcde'
    };
  });

  this.delete('session', function() {
    return {};
  });
}

