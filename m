From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Mon, 26 Jun 2017 16:17:17 +0800
Message-ID: <30880616-4a37-2dd2-1d93-b08ca0f46492@huawei.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjg4WcZgNxD0M27xm2Wp5BRgKO5=hj-wtxwWdrXxCTVPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8382 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdFZISd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Jun 2017 04:18:33 -0400
In-Reply-To: <CAOQ4uxjg4WcZgNxD0M27xm2Wp5BRgKO5=hj-wtxwWdrXxCTVPA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/25 22:19, Amir Goldstein wrote:
> On Sat, Jun 24, 2017 at 8:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> If an "impure && not merged" upper dir have left whiteouts
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
>> ---
>> V3:
>>  - use origin instead of impure flag
>>  - add check in ovl_rename()
>>
>> V2:
>>  - fix comment in ovl_remove_and_whiteout()
>>  - post reproducer to xfstest
>>
>> ---
> 
> Sorry, completely missed the part where you don't prevent
> exposing of whiteouts in readdir.
> I posted a patch that can either be picked by itself of squashed with this one.
> 
> 
>>  fs/overlayfs/dir.c       | 20 ++++++++++++++++----
>>  fs/overlayfs/overlayfs.h |  1 +
>>  fs/overlayfs/util.c      | 13 +++++++++++++
>>  3 files changed, 30 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index a63a716..cbad42f 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -178,6 +178,14 @@ static bool ovl_type_origin(struct dentry *dentry)
>>         return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
>>  }
>>
>> +static bool ovl_is_origin(struct dentry *dentry)
>> +{
>> +       if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>> +               return false;
>> +
> 
> I am not so sure that !OVL_TYPE_UPPER should be skipped.
> in case of ovl_rename() new can be lower with origin and with
> whiteouts, that that lower was once used as upper.
> 

If the dir is !OVL_TYPE_UPPER, we can skip whiteout check because
there's no need to delete the upperdir (it just create a whiteout
in the upper parent), I have already tested this case :)

> Please extend your xfstest to check that whiteouts are not
> exposed also when a former upper layer with origin is
> used in a mount as a lower layer.
> 

Sure, I will do it, thanks.

Thanks,
ZhangYi.
