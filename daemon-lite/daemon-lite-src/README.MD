Mock implementation of a daemon that receives requests over a Unix domain socket.

Upon launch, the server starts to listen for client connection requests. Once connection is established, it waits for requests and replies with the appropriate response.
Each message is exchanged by first sending 8 bytes (64-bits) for the size of the payload, followed by the actual payload.

Currently, this project only supports macOS and Linux.

## Compile & run

### Requirements

- Rust 
- macOS or Linux
- An active internet connection

### Compiling & running

You compile and run the mock daemon using `cargo`:

```
cargo run
```
