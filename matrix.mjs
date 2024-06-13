const swToPHP = await (await fetch('https://raw.githubusercontent.com/FriendsOfShopware/shopware-static-data/main/data/all-supported-php-versions-by-shopware-version.json')).json();

const matrix = [];

for (const swVersion of Object.keys(swToPHP)) {
    if (swVersion.indexOf('6.6') !== 0 || swVersion.indexOf('RC') !== -1) {
        continue;
    }

    for (const phpVersion of swToPHP[swVersion]) {
        matrix.push({
            swVersion,
            phpVersion,
        });
    }
}

console.log(JSON.stringify(matrix, null, 2));
