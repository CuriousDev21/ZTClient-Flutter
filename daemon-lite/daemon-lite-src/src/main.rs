//! # Basic implementation of client server that communicates over Unix domain sockets.
//!
//! Messages are exchanged by first sending header that contains the length of the message
//! followed by the actual message data.

use clap::Parser;
use rand::{rngs::StdRng, Rng, SeedableRng};
use serde::{Deserialize, Serialize};
use std::os::unix::fs::PermissionsExt;
use std::str::from_utf8;
use tokio::io::AsyncReadExt;
use tokio::io::AsyncWriteExt;
use tokio::net::UnixListener;
use tokio::net::UnixStream;
use tokio::time::{sleep, Duration};

const SOCK_PATH: &str = "/tmp/daemon-lite";
const CONN_TOKEN_LEEWAY: i128 = 300_000; // 5 min in milliseconds

#[derive(Serialize, Deserialize, Debug)]
enum RequestType {
    #[serde(rename = "connect")]
    Connect(ConnectionToken),
    #[serde(rename = "disconnect")]
    Disconnect,
    #[serde(rename = "get_status")]
    Status,
}

type ConnectionToken = i128;

#[derive(Serialize, Deserialize, Debug)]
struct DaemonRequest {
    request: RequestType,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
enum ResponseType {
    #[serde(rename = "success")]
    Success,
    #[serde(rename = "error")]
    Error,
}

#[derive(Serialize, Deserialize, Debug)]
struct DaemonResponse {
    status: ResponseType,
    #[serde(skip_serializing_if = "Option::is_none")]
    data: Option<DaemonResponseData>,
    #[serde(skip_serializing_if = "Option::is_none")]
    message: Option<String>,
}

impl DaemonResponse {
    fn with_data(data: &DaemonResponseData) -> Self {
        Self {
            status: ResponseType::Success,
            data: Some(data.clone()),
            message: None,
        }
    }

    fn with_error(error: &str) -> Self {
        Self {
            status: ResponseType::Error,
            data: None,
            message: Some(error.to_string()),
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
struct DaemonResponseData {
    daemon_status: DaemonStatus,
    #[serde(skip_serializing_if = "Option::is_none")]
    message: Option<String>,
}

impl DaemonResponseData {
    fn connected() -> Self {
        Self {
            daemon_status: DaemonStatus::Connected,
            message: None,
        }
    }

    fn normal_disconnect() -> Self {
        Self {
            daemon_status: DaemonStatus::Disconnected,
            message: None,
        }
    }

    fn disconnected_with_error(error: &str) -> Self {
        Self {
            daemon_status: DaemonStatus::Disconnected,
            message: Some(error.to_string()),
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
enum DaemonStatus {
    #[serde(rename = "connected")]
    Connected,
    #[serde(rename = "disconnected")]
    Disconnected,
}

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// How often the requests should fail (once every X calls). Use 1 to always fail. Use 0 to always succeed.
    #[arg(short, long, default_value_t = 4)]
    failure_rate: u64,

    /// The maximum amount of time the connect request can take to establish a connection (in milliseconds).
    #[arg(short, long, default_value_t = 5000)]
    connect_timeout: u64,

    /// The maximum amount of time the disconnect request can take to disconnect (in milliseconds).
    #[arg(short, long, default_value_t = 3000)]
    disconnect_timeout: u64,
}

#[tokio::main]
async fn main() {
    let args = Args::parse();

    start_server(args).await;
}

async fn start_server(args: Args) {
    let _ = std::fs::remove_file(SOCK_PATH);
    let server = UnixListener::bind(SOCK_PATH).unwrap();

    let file_perms = std::fs::Permissions::from_mode(0o777);
    let _ = std::fs::set_permissions(SOCK_PATH, file_perms);

    let task = tokio::spawn(async move {
        println!("Server: Started listening on unix domain socket");

        loop {
            let (conn, remote_addr) = server.accept().await.unwrap();

            println!("Server: New client connection from {:?}", remote_addr);

            match handle_client_connection(&args, conn).await {
                Ok(_) => (),
                Err(err) => println!("Server: Error handling client {:?}", err),
            }
        }
    });
    _ = task.await;
}

/// Handles a client connection.
///
/// This method reads the socket in a loop, until the client disconnects or an error occurs,
/// at which point this method returns.
async fn handle_client_connection(
    args: &Args,
    mut conn: UnixStream,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut daemon_data = DaemonResponseData::normal_disconnect();
    let mut rng = {
        let rng = rand::thread_rng();
        StdRng::from_rng(rng)?
    };
    let failure_rate = args.failure_rate;

    loop {
        let mut data = [0; 1024];
        let mut message_len = [0u8; std::mem::size_of::<usize>()];

        // Read message header bytes
        match conn.read_exact(&mut message_len).await {
            Ok(_) => (),
            Err(err) => {
                println!("Server: Error reading message length: {err}");
                _ = conn.shutdown().await;
                return Ok(());
            }
        }

        // Convert u64 to usize
        let length = usize::from_ne_bytes(message_len);
        let read_buf = &mut data[..length];

        // Read actual message bytes
        match conn.read_exact(read_buf).await {
            Ok(_) => (),
            Err(err) => {
                println!("Server: Error reading message: {err}");
                _ = conn.shutdown().await;
                return Ok(());
            }
        }

        // Deserialize message bytes into DaemonRequest
        let daemon_req_str = from_utf8(read_buf)?;
        println!("Server: Received daemon request (JSON): {daemon_req_str}");
        let daemon_req: DaemonRequest = serde_json::from_str(daemon_req_str)?;

        println!("Server: Parsed request: {:?}", daemon_req);

        // The API calls should randomly fail (approximately once every four calls)
        let should_succeed =
            failure_rate == 0 || (rng.gen_range(1..=failure_rate) % failure_rate) != 0;

        // Handle the daemon request
        let daemon_response = match daemon_req.request {
            RequestType::Connect(token) => {
                // Verify the connection token. It must be within 5 minutes of current UTC timestamp.
                let time_ms = token ^ 0xDEADCAFEBEEFi128;
                let now_ms = i128::from(chrono::offset::Utc::now().timestamp_millis());
                let acceptable_token_range =
                    (now_ms - CONN_TOKEN_LEEWAY)..(now_ms + CONN_TOKEN_LEEWAY);

                if !acceptable_token_range.contains(&time_ms) {
                    DaemonResponse::with_error("Invalid connection token")
                }
                // If we're already connected, asking to connect shoukdn't error, even if
                // `should_succeed` is false.
                else if should_succeed || daemon_data.daemon_status == DaemonStatus::Connected {
                    // Connection delay simulation
                    let sleep_time = rng.gen_range(0..args.connect_timeout);
                    sleep(Duration::from_millis(sleep_time)).await;

                    daemon_data = DaemonResponseData::connected();
                    DaemonResponse::with_data(&daemon_data)
                } else {
                    sleep(Duration::from_millis(args.connect_timeout)).await;
                    DaemonResponse::with_error("Connection to the remote server timed out.")
                }
            }
            RequestType::Disconnect => {
                if should_succeed || daemon_data.daemon_status == DaemonStatus::Disconnected {
                    // Disconnection delay simulation
                    let sleep_time = rng.gen_range(0..=args.disconnect_timeout);
                    sleep(Duration::from_millis(sleep_time)).await;

                    daemon_data = DaemonResponseData::normal_disconnect();
                    DaemonResponse::with_data(&daemon_data)
                } else {
                    DaemonResponse::with_error("There was an error shutting down the server.")
                }
            }
            RequestType::Status => {
                if should_succeed {
                    // If the daemon is connected, it should randomly move to disconnected
                    if daemon_data.daemon_status == DaemonStatus::Connected
                        && failure_rate > 0
                        && (rng.gen_range(1..=failure_rate) % failure_rate) == 0
                    {
                        daemon_data = DaemonResponseData::disconnected_with_error(
                            "The remote server closed the connection",
                        );
                    }
                    DaemonResponse::with_data(&daemon_data)
                } else {
                    DaemonResponse::with_error("Unable to retrieve status: daemon is busy")
                }
            }
        };

        // Serialize the request
        let serialized = serde_json::to_string(&daemon_response)?;

        // Send the message header bytes
        let header = serialized.len().to_ne_bytes();
        let mut _write_bytes = conn.try_write(&header)?;

        // Send the actual message bytes
        println!("Server: Sending response (JSON): {serialized}");
        let _ = conn.writable().await;
        conn.try_write(serialized.as_bytes())?;
    }
}
