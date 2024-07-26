const swToPHP = await (await fetch('https://raw.githubusercontent.com/FriendsOfShopware/shopware-static-data/main/data/all-supported-php-versions-by-shopware-version.json')).json();

const matrix = [];
const alreadyAddedVersion = new Set();

for (const swVersion of Object.keys(swToPHP).reverse()) {
    if ((swVersion.indexOf('6.6') !== 0 && swVersion.indexOf('6.5.8') !== 0) || swVersion.indexOf('RC') !== -1) {
        continue;
    }

    const patchVersion = swVersion.split('.').slice(0, 3).join('.')

    if (alreadyAddedVersion.has(patchVersion)) {
        continue;
    }

    alreadyAddedVersion.add(patchVersion);

    for (const phpVersion of swToPHP[swVersion]) {
        if (phpVersion === '8.1') {
            continue;
        }

        matrix.push({
            tag: patchVersion,
            swVersion,
            phpVersion,
        });
    }
}

console.log(JSON.stringify(matrix, null, 2));
