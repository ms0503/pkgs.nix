use chrono::Utc;
use reqwest::Client;
use scraper::Html;
use scraper::Selector;
use tokio::fs;
use tokio::process::Command;

const BING_BASE_URL: &str = "https://www.bing.com";
const IMAGE_DIR: &str = "/tmp/awww-bing";
const USER_AGENT: &str = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36 Edg/133.0.0.0";

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::builder().user_agent(USER_AGENT).build()?;
    let page = client.get(BING_BASE_URL).send().await?.text().await?;
    let page = Html::parse_document(&page);
    let selector = Selector::parse("div[class=\"hp_top_cover\"]")?;
    let mut elem = page.select(&selector);
    let elem = elem.next().unwrap();
    let mut bg = elem.attr("style").unwrap().split("url(");
    let _ = bg.next();
    let mut bg = bg.next().unwrap().split(")");
    let bg = bg.next().unwrap().replace("\"", "");
    let bg = format!("{}{}", BING_BASE_URL, bg);
    let mut suffix = bg.split(".").last().unwrap().split("&");
    let suffix = suffix.next().unwrap();
    let bg = client.get(&bg).send().await?.bytes().await?;
    let date = Utc::now().format("%Y-%m-%d");
    let filename = format!("{}/{}.{}", IMAGE_DIR, date, suffix);
    if let Err(err) = fs::create_dir(IMAGE_DIR).await {
        match err.kind() {
            std::io::ErrorKind::AlreadyExists => {}
            _ => return Err(err)?
        }
    }
    fs::write(&filename, bg).await?;
    Command::new("awww")
        .args(&["img", &filename])
        .spawn()
        .unwrap()
        .wait()
        .await?;
    Ok(())
}
