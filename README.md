# iChatReader
A macOS app to read old iChat message logs. Very basic for now, but more to
come.

Requires macOS 12 Monterey or greater. Runs on either Intel or Apple Silicon,
with the pre-built binary being a Universal binary.

Some code for this project was forked from `ichat2json` on [GitHub](https://github.com/matrix-hacks/ichat2json)

## Installing

Download the installer image containing the pre-built Universal Binary from the
release page. Mount the installer disk and copy the iChatReader app into
`Applications`.

If you encounter a security warning about that iChatReader "can't be opened
because Apple cannot check it for malicious software", you will need to manage
security settings in the Settings app.

<img src="./apple-security-dialog.png" alt="It's not malicious, just unsigned 😅" width="300"/>


In the Settings app, go to `Settings > Privacy & Security` and click on the
"Open Anyway" button to un-quarantine the app.

<img src="./unblock-ichatreader.png" width="500"/>
