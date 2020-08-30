use tide::{Body, Response};
use serde::Serialize;

pub type Request = tide::Request<()>;

pub fn to_json(body: &impl Serialize) -> tide::Result<Response> {
    let mut res = Response::new(200);
    res.set_body(Body::from_json(body)?);
    Ok(res)
}
