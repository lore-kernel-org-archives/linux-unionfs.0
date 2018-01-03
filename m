From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Wed, 3 Jan 2018 17:48:53 +0200
Message-ID: <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
 <1514992475-8142-3-git-send-email-amir73il@gmail.com> <1514994062.3458.14.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35568 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbeACPsz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 10:48:55 -0500
In-Reply-To: <1514994062.3458.14.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 3, 2018 at 5:41 PM, Jeff Layton <jlayton@kernel.org> wrote:
> On Wed, 2018-01-03 at 17:14 +0200, Amir Goldstein wrote:
>> The time values in stat and inode may differ for overlayfs and stat time
>> values are the correct ones to use. This is also consistent with the fact
>> that fill_post_wcc() also stores stat time values.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/nfsd/nfs3xdr.c | 31 ++++++++++++++++++++++++++++++-
>>  fs/nfsd/nfs4xdr.c |  2 +-
>>  fs/nfsd/nfsfh.h   | 28 ++++++----------------------
>>  3 files changed, 37 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
>> index 2758480555fa..1a70581e1cb2 100644
>> --- a/fs/nfsd/nfs3xdr.c
>> +++ b/fs/nfsd/nfs3xdr.c
>> @@ -251,6 +251,34 @@ encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
>>  }
>>
>>  /*
>> + * Fill in the pre_op attr for the wcc data
>> + */
>> +void fill_pre_wcc(struct svc_fh *fhp)
>> +{
>> +     struct inode    *inode;
>> +     struct kstat    stat;
>> +     __be32 err;
>> +
>> +     if (fhp->fh_pre_saved)
>> +             return;
>> +
>> +     inode = d_inode(fhp->fh_dentry);
>> +     err = fh_getattr(fhp, &stat);
>> +     if (err) {
>> +             /* Grab the times from inode anyway */
>> +             stat.mtime = inode->i_mtime;
>> +             stat.ctime = inode->i_ctime;
>> +             stat.size  = inode->i_size;
>> +     }
>> +
>
> Might be best to instead just not supply pre/post op attrs if the
> getattr fails? They are technically optional with v3 -- we can just set
> the attributes_follow bit to false there.

I considered to set fh_pre_saved = false on error just like
fill_post_wcc() does, but wasn't sure of the consequences or how to test
for that matter, so I chose a more delicate fallback instead.


>
> For v4, it's a little more complicated. Scraping it out of the inode
> might be necessary for the cases where we need a change_info4.
>
> Either way, it'd be good to know that these getattrs are failing if this
> occurs. Maybe a KERN_WARNING printk or something might be good there?
>

As you wish, but fill_post_wcc() does not emit a warning, so...

I'll wait for feedback from Bruce as well.
Let me know the error handing of your choice.

Thanks,
Amir.
