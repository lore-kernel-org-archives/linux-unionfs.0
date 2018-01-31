From: yangerkun <yangerkun@huawei.com>
Subject: [QUESTION] problem about origin xattr
Date: Wed, 31 Jan 2018 18:36:12 +0800
Message-ID: <1594ffa4-1877-0331-d662-bf9e1e0dcca1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4751 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751700AbeAaKgc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 05:36:32 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A1B1B104A1A29
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 18:36:18 +0800 (CST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, amir73il@gmail.com, miklos@szeredi.hu, miaoxie@huawei.com

Hi,

While thinking about "origin" xattr, i find a problem which retrieval 
methods show as below:

$mkdir lower lower1 lower2 upper work merge
$touch lower1/a
$mount -t overlay -olowerdir=lower:lower1,upperdir=upper,workdir=work 
merge merge
$echo abc > merge/a
$ls -li merge/a
Then, we can get the ino of file a equals to the ino of lower1/a.
$umount merge
$mount -t overlay -olowerdir=lower:lower2,upperdir=upper,workdir=work 
merge merge
$ls -li merge/a

The ino for file a is same as file lower1/a, while there is no file a in 
lower and lower2. Because ovl_get_origin will get the wrong origin.

Thanks,
yangerkun
