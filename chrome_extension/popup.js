document.addEventListener('DOMContentLoaded', function () {
    var saveButton = document.getElementById('saveJobButton');
    saveButton.addEventListener('click', saveJob);
});

async function saveJob() {

    // get current job url
    cheddarUrl = "http://127.0.0.1:3000/"


    var currentTabUrl = await getCurrentTab();
    console.log("currentTabUrl:", currentTabUrl);

    // make api call
    console.log(chrome.cookies.get({ url: cheddarUrl, name: "_cheddar_session" }));

    const myHeaders = new Headers();
    myHeaders.append("x-api-key", "b1e30ea0862236d562de386d5fb9184292956c");

    const requestOptions = {
        method: "POST",
        headers: myHeaders,
        redirect: "follow",
        credentials: "include"
    };

    fetch(`${cheddarUrl}/api/v0/add_job?posting_url=${currentTabUrl}`, requestOptions)
        .then((response) => {
            console.log("response: ", response)
            console.log("response text: ", response.text());
            if (!response.ok) {
                throw new Error('Unexpected response status: ' + response.status);
            }
            if (response.status == 200) {
                if (response.redirected == true) {
                    chrome.tabs.create({
                        url: response.url
                    })
                }
                else {
                    const messageElement = document.getElementById('message');
                    messageElement.style.display = 'block';
                    setTimeout(() => {
                        messageElement.style.display = 'none';
                    }, 15000);
                }
            }
        })
        .catch((error) => console.error(error));

}



/**
 * 
 * @returns {string} the url of the current tab
 * 
 */
async function getCurrentTab() {
    let queryOptions = { active: true, lastFocusedWindow: true };
    // `tab` will either be a `tabs.Tab` instance or `undefined`.
    let [tab] = await chrome.tabs.query(queryOptions);
    return tab.url;
}


