# ProtoLink - Link into your ProtoNet

ProtoLink is a library for interfacing with ProtoNet, the next-gen internet infrastructure. Truly social and people-powered.

## Usage

    protonet = ProtoLink::Protonet.new 'myfulldomain', :token => 'lk3364b3d8fee4d80sse5g561caf7h9f3ea7blsue'
    room = protonet.rooms.first
    room.speak 'Hello world!'

    room = protonet.find_room_by_guest_hash 'dudemaster', 'cowboy'
    room.speak 'Hello world!'

## Installation

    gem install protolink
  
## How to contribute

If you find what looks like a bug:

1. Check the GitHub issue tracker to see if anyone else has had the same issue.
   http://github.com/protonet/protolink/issues/
2. If you don't see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on github.
   http://github.com/protonet/protolink
2. Make your changes with tests.
3. Commit the changes without making changes to the Rakefile, VERSION, or any other files that aren't related to your enhancement or fix
4. Send a pull request.
