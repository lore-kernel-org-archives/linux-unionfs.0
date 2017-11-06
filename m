From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 7/8] ovl: update cache version of impure parent on rename
Date: Mon, 6 Nov 2017 12:06:09 +0200
Message-ID: <CAOQ4uxi7NNwvnvcjo3qSFG2h8r9jTx0NrrruJCzraf3bA8WD5A@mail.gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
 <1509655091-13630-8-git-send-email-amir73il@gmail.com> <CAJfpegvT8QQcHi5VmoG8SSLd9kSZj6OoSzMq+G29pOpXbo8-5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:55576 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdKFKGK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 05:06:10 -0500
Received: by mail-yw0-f193.google.com with SMTP id t11so7313761ywg.12
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Nov 2017 02:06:10 -0800 (PST)
In-Reply-To: <CAJfpegvT8QQcHi5VmoG8SSLd9kSZj6OoSzMq+G29pOpXbo8-5w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 11:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Nov 2, 2017 at 9:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> ovl_rename() updates dir cache version for impure old parent if an entry
>> with copy up origin is moved into old parent, but it did not update
>> cache version if the entry moved out of old parent has a copy up origin.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/dir.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index ef533198be45..26aef3b5f007 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -1075,9 +1075,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>>                         drop_nlink(d_inode(new));
>>         }
>>
>> -       ovl_dentry_version_inc(old->d_parent,
>> -                              !overwrite && ovl_type_origin(new));
>> +       ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old));
>>         ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
>> +       if (!overwrite)
>> +               ovl_dentry_version_inc(old->d_parent, ovl_type_origin(new));
>
> How about the opposite (i.e. newdir losing impurity)?  That can happen two ways:
>
>   - overwriting copied up file (new) with pure one (old)
>   - exchange copied up file (new) with pure one (old)
>
> Also I'd merge the two version increments into one, although that
> doesn't really matter:
>
> -    ovl_dentry_version_inc(old->d_parent,
> -                   !overwrite && ovl_type_origin(new));
> -    ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
> +    ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old) ||
> +                   (!overwrite && ovl_type_origin(new)));
> +    ovl_dentry_version_inc(new->d_parent,
> +                   ovl_type_origin(old) || ovl_type_origin(new));
>
> Fixed up the patch, but tell me if I'm missing something here.
>

I think you are.
Both my version and your version are wrong because the argument
'impurity' should really be 'impurity_change'

so if we have:
oldimpurity = ovl_type_origin(old);
newimpurity = d_inode(new) ? ovl_type_origin(new) : false;

version increment should really be something like this:
ovl_dentry_version_inc(old->d_parent, oldimpurity ^ (overwrite ?
newimpurity : false));
ovl_dentry_version_inc(new->d_parent, oldimpurity ^ newimpurity);


I think...

Amir.
