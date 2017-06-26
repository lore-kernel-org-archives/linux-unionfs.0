From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Mon, 26 Jun 2017 20:25:23 +0800
Message-ID: <915a6a5a-bd46-fa6f-8d59-035231f86cdd@huawei.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxg4epd0RzZFF6swO_KgffXoUuvS1Tmeamf6Y2LCSwc5gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:8855 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdFZMa1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Jun 2017 08:30:27 -0400
In-Reply-To: <CAOQ4uxg4epd0RzZFF6swO_KgffXoUuvS1Tmeamf6Y2LCSwc5gQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/26 18:19, Amir Goldstein Wrote:
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
> Sorry, I keep finding more stuff...
> 
>>  {
>> @@ -331,12 +339,14 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
>>          * replace it with an exact replica of itself.
>>          *
>>          * If no upperdentry then skip clearing whiteouts.
>> +        * Origined directory may have whiteouts, should clean up.
>>          *
>>          * Can race with copy-up, since we don't hold the upperdir mutex.
>>          * Doesn't matter, since copy-up can't create a non-empty directory
>>          * from an empty one.
>>          */
>> -       if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
>> +       if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
>> +                                    ovl_is_origin(dentry)))
>>                 ret = ovl_clear_empty(dentry, &list);
>>
> 
> We may have been a little stupid here.
> It does not matter if MERGE/ORIGIN/whatever.
> We already checked for whiteout existence in ovl_check_empty_dir(),
> so actually ovl_clear_empty() is needed IFF
> !OVL_TYPE_UPPER(type) && !list_empty(&list).
> 

Clerical error? Do you mean OVL_TYPE_UPPER(type) && !list_empty(&list) ?

> Actually, list can be non-empty due to whiteouts in lower dir
> and then ovl_cleanup_whiteouts() will report errors when trying to
> cleanup those lower whiteouts (if I am reading the code correctly).
> Please test case of whiteouts in both lower and upper dirs of a merge
> dir. rmdir may succeed, but with errors.
> 

Current !list_empty(&list) is always true because the list contain "." and "..",
so (OVL_TYPE_UPPER(type) && !list_empty(&list)) is equal to OVL_TYPE_UPPER(type).

For the whiteouts in both lower and upper dirs of a merge dir case, ovl_clear_empty()
only clear the upper dir, it will with errors. I think the only sideeffect is
the pure upperdir will call ovl_clear_empty too.

> To fix this properly, need another hunk of my readdir patch (that's
> actually a hunk I stole off Miklos' old readdir patch) that stores the
> p->idx field in the list/cache.
> 
> Then, ovl_check_empty_dir() can return a list of elements with
> (p->is_whiteout && p->idx == 0) and ovl_cleanup_whiteouts() can
> can be called IFF !list_empty(&list) to clean them.
> 

It's a good idea, let ovl_check_empty_dir() only return upper whiteouts,
I will try it.

Thanks,
ZhangYi.
