From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Sun, 25 Jun 2017 10:28:13 +0300
Message-ID: <CAOQ4uxib18RfpYyMTUoCVLAnNoYhyk0yhq0NE=voPDGzEo8x2Q@mail.gmail.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com> <CAOQ4uxjsc6TiMyNWuoKUk3pNa_jEa3Ov_mfFfB6jvEd+XR9xVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36376 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdFYH2O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2017 03:28:14 -0400
Received: by mail-oi0-f67.google.com with SMTP id p66so6723332oia.3
        for <linux-unionfs@vger.kernel.org>; Sun, 25 Jun 2017 00:28:14 -0700 (PDT)
In-Reply-To: <CAOQ4uxjsc6TiMyNWuoKUk3pNa_jEa3Ov_mfFfB6jvEd+XR9xVQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Sat, Jun 24, 2017 at 6:55 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Jun 24, 2017 at 8:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> If an "impure && not merged" upper dir have left whiteouts


The mention of "impure" in commit message and title is
slightly out of date the with the patch itself.
An "origin" upper with whiteouts and no copy ups is not
considered "impure".

>> (last mount created), ovl cannot clear this dir when we
>> removing it, which may lead to rmdir fail or temp file left
>> in workdir.
>>
>> Simple reproducer:
>>   mkdir lower upper work merge
>>   mkdir -p lower/dir
>>   touch lower/dir/a
>>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>>     workdir=work merge
>>   rm merge/dir/a
>>   umount merge
>>   rm -rf lower/*
>>   touch lower/dir  (*)
>>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>>     workdir=work merge
>>   rm -rf merge/dir
>>
>> Syslog dump:
>>   overlayfs: cleanup of 'work/#7' failed (-39)
>>
>> (*): if we are not creat this file, the result is different:
>>   rm: cannot remove "dir/": Directory not empty
>>
>> This patch add explicitly check of OVL_XATTR_ORIGIN, use
>> (merge || origin) to indicate the dir may have whiteouts.
>> Finally, check and clean up the dir when deleting it.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>
>
> Looks good.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
