const swToPHP = await (await fetch('https://raw.githubusercontent.com/FriendsOfShopware/shopware-static-data/main/data/all-supported-php-versions-by-shopware-version.json')).json();

const matrix = [];
const alreadyAddedVersion = new Set();

const customSort = (a, b) => {
    const aParts = a.split('.').map(Number);
    const bParts = b.split('.').map(Number);

    for (let i = 0; i < Math.max(aParts.length, bParts.length); i++) {
        if ((aParts[i] || 0) > (bParts[i] || 0)) return -1;
        if ((aParts[i] || 0) < (bParts[i] || 0)) return 1;
    }
    return 0;
};

for (const swVersion of Object.keys(swToPHP).sort(customSort)) {
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
