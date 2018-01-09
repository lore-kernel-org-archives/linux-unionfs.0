From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 14/23] ovl: index all files on copy up with 'verify=on'
Date: Tue, 9 Jan 2018 18:50:15 +0200
Message-ID: <CAOQ4uxhQc+p3q_K6PdJ+P4C3p2Cv6RhKttAe5yQ8GnASUrAd5A@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-15-git-send-email-amir73il@gmail.com> <20180109164551.GA11872@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:40811 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759805AbeAIQuQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:50:16 -0500
Received: by mail-yw0-f193.google.com with SMTP id g191so5896549ywe.7
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:50:16 -0800 (PST)
In-Reply-To: <20180109164551.GA11872@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 6:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 04, 2018 at 06:40:09PM +0200, Amir Goldstein wrote:
>> With the 'verify' feature enabled, all files are indexed on copy up.
>> The copy up origin inode of an indexed non-dir can be used as a unique
>> identifier of the overlay object.
>>
>> This is going to be used for NFS export.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/util.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> index 0254d7f0d401..f40351dcea7b 100644
>> --- a/fs/overlayfs/util.c
>> +++ b/fs/overlayfs/util.c
>> @@ -491,6 +491,10 @@ bool ovl_need_index(struct dentry *dentry)
>>       if (!lower || !ovl_indexdir(dentry->d_sb))
>>               return false;
>>
>> +     /* Index all files for unique origin verification */
>> +     if (!d_is_dir(lower) && ovl_verify(dentry->d_sb))
>> +             return true;
>
> If all files are indexd up with verify=on, what is this check about
> "!d_is_dir()"?
>


Removed by next patch that implements indexing of dir on copy up.

Thanks,
Amir.
