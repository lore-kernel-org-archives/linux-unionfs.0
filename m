Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC70C4338F
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 10:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D77610CB
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Aug 2021 10:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhHGKRW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Aug 2021 06:17:22 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13296 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbhHGKRW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Aug 2021 06:17:22 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GhdS9361Lz83hn
        for <linux-unionfs@vger.kernel.org>; Sat,  7 Aug 2021 18:12:09 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 7 Aug 2021 18:17:03 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 dggema761-chm.china.huawei.com (10.1.198.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 18:17:03 +0800
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>,
        <linux-unionfs@vger.kernel.org>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Subject: [QUESTION] Why overlayfs cannot mounted as nfs_export and metacopy?
Message-ID: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
Date:   Sat, 7 Aug 2021 18:17:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi, all.

As title said. I wonder to know the reason for overlayfs mount failure 
with '-o nfs_export=on,metacopy=on'.

I modified kernel to enable these two options 'on',  it looks like that 
overlayfs can still work fine under nfs_v4.

Besides, I can get no more information about the reason from source 
code, maybe I missed something.

