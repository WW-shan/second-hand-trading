export function formatDateTime(value) {
    if (!value) {
        return '';
    }
    return `${value.substring(0, 10)} ${value.substring(11, 19)}`;
}

export function parsePictureList(pictureList) {
    if (!pictureList) {
        return [];
    }
    if (Array.isArray(pictureList)) {
        return pictureList;
    }
    try {
        return JSON.parse(pictureList);
    } catch (error) {
        return [];
    }
}

export function firstPicture(pictureList) {
    const list = parsePictureList(pictureList);
    return list.length > 0 ? list[0] : '';
}

export function mapIdlePreview(item) {
    return {
        ...item,
        timeStr: formatDateTime(item.releaseTime),
        imgUrl: firstPicture(item.pictureList)
    };
}

export function mapOrderPreview(order) {
    const idleItem = order.idleItem || {};
    return {
        id: order.id,
        imgUrl: firstPicture(idleItem.pictureList),
        idleName: idleItem.idleName,
        idleDetails: idleItem.idleDetails,
        timeStr: formatDateTime(order.createTime),
        idlePrice: order.orderPrice,
        orderStatus: order.orderStatus
    };
}

export function mapFavoritePreview(favorite) {
    const idleItem = favorite.idleItem || {};
    return {
        favoriteId: favorite.id,
        id: idleItem.id,
        imgUrl: firstPicture(idleItem.pictureList),
        idleName: idleItem.idleName,
        idleDetails: idleItem.idleDetails,
        timeStr: formatDateTime(favorite.createTime),
        idlePrice: idleItem.idlePrice
    };
}
