From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 0/3] Overlayfs fixes for exposed whiteouts
Date: Wed, 1 Nov 2017 08:08:42 +0200
Message-ID: <CAOQ4uxhkMB1_=r0MH-Fb6W01BCh-ch9UnWr1J64PrrOdBbN+WQ@mail.gmail.com>
References: <1509486350-21362-1-git-send-email-amir73il@gmail.com> <0b81aec4-beb5-6c01-3093-a439c37df462@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:48918 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdKAGIo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 02:08:44 -0400
Received: by mail-yw0-f195.google.com with SMTP id q1so1031026ywh.5
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 23:08:44 -0700 (PDT)
In-Reply-To: <0b81aec4-beb5-6c01-3093-a439c37df462@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 5:12 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/11/1 5:45, Amir Goldstein Wrote:
>> Miklos,
>>
>> Let's call my previous version v5 (Zhangyi's last post was v4).
>>
>> Changes since v5:
>> - Split ovl_check_empty_and_clear() changes from bug fix patch
>> - Cache "origin" xattr of non-merge dir in inode flag OVL_WHITEOUTS
>>   (OVL_ORIGIN would have been too confusing)
>> - Replace layer idx with is_upper boolean
>>
>> I tested these changes with upstream xfstest overlay/031 by Zhangyi.
>> Pushed to ovl-whiteouts branch [1] and rebased the non-samefs patches
>> on top of it [2].
>>
>
> All these three patches looks good to me, and I tested these too.
>

Thanks for review and testing!

Oh! I messed up the authorship of your patch when I split it.
Pushed fixed version with description of my changes to [1].

Miklos,

Please take updated commits from my branch.

Thanks,
Amir.

>>
>> [1] https://github.com/amir73il/linux/commits/ovl-whiteouts
>> [1] https://github.com/amir73il/linux/commits/overlayfs-devel
>>
>> Amir Goldstein (3):
>>   ovl: no direct iteration for dir with origin xattr
>>   ovl: simplify ovl_check_empty_and_clear()
>>   ovl: fix rmdir problem on non-merge dir with origin xattr
>>
>>  fs/overlayfs/dir.c       | 18 ++++++++++------
>>  fs/overlayfs/inode.c     |  5 +++++
>>  fs/overlayfs/overlayfs.h |  4 ++++
>>  fs/overlayfs/readdir.c   | 56 ++++++++++++++++++++++++++++++++++++++----------
>>  fs/overlayfs/util.c      | 13 +++++++++++
>>  5 files changed, 79 insertions(+), 17 deletions(-)
>>
>
