function getRandomArbitrary(min, max) {
    return Math.pow(10, Math.random() * (Math.log10(max) - Math.log10(min)) + Math.log10(min));
}

function generateRandomHexString(length) {
    let result = '0x';
    const characters = '0123456789abcdef';

    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        result += characters.charAt(randomIndex);
    }

    return result;
}

function generateRandomData(numTimes) {
    const dataArray = [];

    for (let i = 0; i < numTimes; i++) {
        const firstPart = generateRandomHexString(40);
        const secondPart = i.toString();
        const thirdPart = parseInt(getRandomArbitrary(1e15, 1e22)).toString();

        const textToPrint = [];
        textToPrint.push(firstPart);
        textToPrint.push(secondPart);
        textToPrint.push(thirdPart);


        dataArray.push(textToPrint);
    }

    // Add some hardcoded values at random places
    dataArray[getRandomInt(numTimes - 1)][0] = "0x328809Bc894f92807417D2dAD6b7C998c1aFdac6"; // makeAddr("alice")
    dataArray[getRandomInt(numTimes - 1)][0] = "0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e"; // makeAddr("bob")
    dataArray[getRandomInt(numTimes - 1)][0] = "0xA4d4c1f8a763Ef6a0140D04291eCEef913Ffc272"; // makeAddr("carol")
    dataArray[getRandomInt(numTimes - 1)][0] = "0x7E09429585169ABA1759346eb6b94C91f3C7203b"; // makeAddr("dave")

    return dataArray;
}

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

export default generateRandomData;