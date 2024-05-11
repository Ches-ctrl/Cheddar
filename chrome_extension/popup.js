document.addEventListener('DOMContentLoaded', function() {
    var saveButton = document.getElementById('saveJobButton');
    saveButton.addEventListener('click', saveJob);
});

async function saveJob() {
    // get current job url

    var currentTabUrl = await getCurrentTab();

    // make api call
    jobAPIcall("", currentTabUrl, "http://127.0.0.1:3000/api/v0/add_job")
        .then(response => response.json()) // Transform the response to JSON
        .then(data => {
            console.log(data); // Handle the data from the response
        })
        .catch(error => {
            console.error('Error:', error); // Handle any errors
        });
}

/**
 * 
 * @returns {string} the url of the current tab
 * 
 */
async function getCurrentTab() {
    let queryOptions = { active: true, lastFocusedWindow: true };
    let tab = await chrome.tabs.query(queryOptions);
    return tab.url;
}


/**
 * 
 * @param {string} csrfToken 
 * @param {string} job_url: the job to be saved
 * @param {string} api_url: the url of the api
 * @returns a promise from the api
 * 
 */
function jobAPIcall(csrfToken, job_url, api_url) {
    return fetch(api_url, {
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrfToken // Include the CSRF token here
        },
        body: JSON.stringify({
            posting_url: job_url
        })
    })
}


