From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/17] ovl: encode non-indexed upper file handles
Date: Mon, 15 Jan 2018 14:07:17 +0200
Message-ID: <CAOQ4uxi7m5mPrgsHHBWQ+ADaPM4pBQ3LtOgJyJVQPNO2eb84PQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-6-git-send-email-amir73il@gmail.com> <CAJfpegvAHw2f31JqnTuKaUaZvv3DpwvDYW9Q2LJj-kGL6tzkmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:45658 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754478AbeAOMHS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:07:18 -0500
In-Reply-To: <CAJfpegvAHw2f31JqnTuKaUaZvv3DpwvDYW9Q2LJj-kGL6tzkmQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 15, 2018 at 1:58 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> We only need to encode origin if there is a chance that the same object was
>> encoded pre copy up and then we need to stay consistent with the same
>> encoding also after copy up.
>>
>> In case a non-pure upper is not indexed, then it was copied up before NFS
>> export support was enabled. In that case, we don't need to worry about
>> staying consistent with pre copy up encoding and we encode an upper file
>> handle.
>>
>> This mitigates the problem that with no index, we cannot find an upper
>> inode from origin inode, so we cannot decode a non-indexed upper from
>> origin file handle.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/export.c | 28 +++++++++++++++++++++++-----
>>  1 file changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 48ae02f3acb8..919d43aaa387 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -19,6 +19,28 @@
>>  #include <linux/ratelimit.h>
>>  #include "overlayfs.h"
>>
>> +/*
>> + * We only need to encode origin if there is a chance that the same object was
>> + * encoded pre copy up and then we need to stay consistent with the same
>> + * encoding also after copy up. If non-pure upper is not indexed, then it was
>> + * copied up before NFS export was enabled. In that case we don't need to worry
>> + * about staying consistent with pre copy up encoding and we encode an upper
>> + * file handle.
>> + */
>> +static bool ovl_should_encode_origin(struct dentry *dentry)
>> +{
>> +       /* Root dentry was born upper */
>> +       if (dentry == dentry->d_sb->s_root)
>> +               return false;
>
> Root can be lower, no (when there's no upper layer at all)?  The
> comment is confusing at best.
>

Probably more than "just confusing" as I did not test NFS export
with no-upper overlayfs case.
At best encode will fail.

I will test this setup.

Thanks,
Amir.
