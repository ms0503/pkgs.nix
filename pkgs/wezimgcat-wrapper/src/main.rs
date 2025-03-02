use regex::Regex;
use std::env;
use tokio::process::Command;

const SUPPORTED_SUFFIX_PATTERN: &str = r"bmp|gif|jpe?g|png|tiff?";

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let file_pattern = Regex::new(r"(.+)\.(.+)")?;
    let supported_suffix_pattern = Regex::new(SUPPORTED_SUFFIX_PATTERN)?;
    let mut args = vec![];
    let mut threads = vec![];
    for arg in env::args().skip(1) {
        if let Some(filename) = file_pattern.captures(&arg) {
            let (filename, [basename, suffix]) = filename.extract();
            if supported_suffix_pattern.is_match(suffix) {
                args.push(arg);
            } else {
                let new_filename = format!("{}.png", basename);
                let thread = Command::new("magick")
                    .args(&[filename, &new_filename])
                    .spawn()?;
                threads.push(thread);
                args.push(new_filename);
            }
        } else {
            args.push(arg);
        }
    }
    for mut thread in threads {
        thread.wait().await?;
    }
    Command::new("wezterm")
        .arg("imgcat")
        .args(args)
        .spawn()?
        .wait()
        .await?;
    Ok(())
}
