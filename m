From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 07/11] ovl: set the COPYUP type flag for non-dirs
Date: Wed, 26 Apr 2017 17:57:15 +0300
Message-ID: <CAOQ4uxh1Yp94g24Bjo5ZhvXc6JkRFQOsOxJkspQ+xX0=satvZg@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-8-git-send-email-amir73il@gmail.com> <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36055 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041188AbdDZO5V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 10:57:21 -0400
In-Reply-To: <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 26, 2017 at 5:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> For directory entries, non zero oe->numlower implies OVL_TYPE_MERGE.
>> Define a new type flag OVL_TYPE_COPYUP to indicate that an entry is
>> a target of a copy up.
>>
>> For directory entries COPYUP = MERGE && UPPER. For non-dir entries
>> non zero oe->numlower implies COPYUP, but COPYUP does not imply
>> non zero oe->numlower.  COPYUP can also be set on lookup when detecting
>> an overlay.fh xattr on a non-dir, even if that fh cannot be followed.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c     |  3 +++
>>  fs/overlayfs/overlayfs.h |  2 ++
>>  fs/overlayfs/util.c      | 12 ++++++++----
>>  3 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 318092a..73a8879 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -386,6 +386,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>                 }
>>                 if (d.opaque)
>>                         type |= __OVL_PATH_OPAQUE;
>> +               /* overlay.fh xattr implies this is a copy up */
>> +               if (d.fh)
>> +                       type |= __OVL_PATH_COPYUP;
>>         }
>>
>>         /*
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index 08002ce..d0bb538 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -13,11 +13,13 @@ enum ovl_path_type {
>>         __OVL_PATH_UPPER        = (1 << 0),
>>         __OVL_PATH_MERGE        = (1 << 1),
>>         __OVL_PATH_OPAQUE       = (1 << 2),
>> +       __OVL_PATH_COPYUP       = (1 << 3),
>>  };
>>
>>  #define OVL_TYPE_UPPER(type)   ((type) & __OVL_PATH_UPPER)
>>  #define OVL_TYPE_MERGE(type)   ((type) & __OVL_PATH_MERGE)
>>  #define OVL_TYPE_OPAQUE(type)  ((type) & __OVL_PATH_OPAQUE)
>> +#define OVL_TYPE_COPYUP(type)  ((type) & __OVL_PATH_COPYUP)
>>
>>  #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
>>  #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> index dba9753..89789bc 100644
>> --- a/fs/overlayfs/util.c
>> +++ b/fs/overlayfs/util.c
>> @@ -101,11 +101,15 @@ enum ovl_path_type ovl_update_type(struct dentry *dentry, bool is_dir)
>>         if (oe->__upperdentry) {
>>                 type |= __OVL_PATH_UPPER;
>>                 /*
>> -                * Non-dir dentry can hold lower dentry from before
>> -                * copy-up.
>> +                * oe->numlower implies a copy up, but copy up does not imply
>> +                * oe->numlower.  It can also be set on lookup when detecting
>> +                * an overlay.fh xattr on a non-dir that cannot be followed.
>
> The code looks fine, but I don't understand the comment.  Why would we
> set COPYUP flag when the fh cannot be followed?
>

See patch #8 ovl: redirect non-dir by path on rename

overlay.fh *is* the indication of a copy up and non-dir copy ups
should be redirected
on rename.

With this, copying the layers will not break the constant inode property.
upper files will continue to follow by path to origin and report the
new (post copy)
stable inode number.
