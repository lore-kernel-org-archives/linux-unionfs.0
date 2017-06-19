From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Mon, 19 Jun 2017 11:28:51 +0300
Message-ID: <CAOQ4uximW7=COjJPvLbCmE93UZ-ZYNdkEuFji-xXwHfSkjqqaw@mail.gmail.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com> <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33126 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdFSI2w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 04:28:52 -0400
Received: by mail-ot0-f196.google.com with SMTP id q16so7589618otb.0
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 01:28:52 -0700 (PDT)
In-Reply-To: <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, miaoxie@huawei.com

On Mon, Jun 19, 2017 at 10:59 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> There is another problem about impure upper dir which have left
>> whiteout files(the first one is whiteout exposure). If an
>> "impure && not merged" upper dir have left whiteout files
>> (last mount created), ovl cannot clear this dir when we
>> removing it, which may lead to rmdir fail or temp file left
>> in workdir.
>>
>> Reproducer:
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
>> This patch add impure flag on parent dir in ovl_remove_and_whiteout()
>> to indicate the dir is impure, and then check and clean it when
>> removing this dir.
>
> I still don't like adding the impure flag because of a whiteout.
> Impure dir means it contains a copied up object.  In fact a valid (but
> probably not worthwhile) optimizition would be to remove the impure
> flag on removal of the last copied up object.
>
> What's wrong with testing for (origin || merge) to see if we need to
> check for whiteouts?
>

Fine by me.

Yi,

Please note that you cannot use the test OVL_TYPE_ORIGIN(type)
in ovl_dir_is_real(), because that flag is only set when the lower
dentry is found by lookup. Instead, you should explicitly check for
existence of OVL_XATTR_ORIGIN.
Note that even ovl_get_origin_fh() is too strict, because it discards
empty (unkown) origin, but for your use case, unknown origin is also
candidate to contain whiteouts.

Amir.
