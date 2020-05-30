Return-Path: <SRS0=mld1=7M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DECDC433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 00:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD9F20810
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 00:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgE3A7K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 20:59:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5395 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728297AbgE3A7K (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 20:59:10 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CF3C11D1518E54A08DF8;
        Sat, 30 May 2020 08:59:07 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.218) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 30 May 2020
 08:59:03 +0800
Subject: Re: [PATCH 0/3] overlayfs: Do not check metacopy in ovl_get_inode()
To:     Vivek Goyal <vgoyal@redhat.com>, <amir73il@gmail.com>
CC:     <miklos@szeredi.hu>, <linux-unionfs@vger.kernel.org>
References: <20200529212952.214175-1-vgoyal@redhat.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <ca484e51-f978-2985-bf51-b29cc4476e83@huawei.com>
Date:   Sat, 30 May 2020 08:59:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200529212952.214175-1-vgoyal@redhat.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.212.218]
X-CFilter-Loop: Reflected
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Ok, I will try it.

ÔÚ 2020/5/30 5:29, Vivek Goyal Ð´µÀ:
> This series tries to implement Amir's suggestion of initializing
> OVL_UPPERDATA in callers of ovl_get_inode() and move checking of
> metacopy xattr out of ovl_get_inode().
> 
> It also has to patches to cleanup metacopy logic a bit and make it
> little more readable and understandable in ovl_lookup().
> 
> yangerkun, can you please make sure if this patch series fixes the
> xfstest issue you were facing once in a while.
> 
> Vivek Goyal (3):
>    overlayfs: Simplify setting of origin for index lookup
>    overlayfs: ovl_lookup(): Use only uppermetacopy state
>    overlayfs: Initialize OVL_UPPERDATA in ovl_lookup()
> 
>   fs/overlayfs/dir.c   |  2 +
>   fs/overlayfs/inode.c | 11 +-----
>   fs/overlayfs/namei.c | 88 +++++++++++++++++++++++---------------------
>   3 files changed, 50 insertions(+), 51 deletions(-)
> 

