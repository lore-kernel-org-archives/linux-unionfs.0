From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 02/15] ovl: store file handle of lower inode on copy up
Date: Wed, 3 May 2017 18:32:07 +0300
Message-ID: <CAOQ4uxh5AyN767cyvshuFuWQLivndMitNex+EyhdB_gsr=E70w@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <1493646126-10101-3-git-send-email-amir73il@gmail.com> <CAOQ4uxhPdfA=dPnMGfDzDQpL-_aVDfc25ejYpnK25Zt0QSZXEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34764 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdECPcN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2017 11:32:13 -0400
In-Reply-To: <CAOQ4uxhPdfA=dPnMGfDzDQpL-_aVDfc25ejYpnK25Zt0QSZXEw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 3, 2017 at 6:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, May 1, 2017 at 4:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Sometimes it is interesting to know if an upper file is pure
>> upper or a copy up target, and if it is a copy up target, it
>> may be interesting to find the copy up origin.
>>
>> This will be used to preserve lower inode numbers across copy up.
>>
>> Store the lower inode file handle in upper inode extended attribute
>> overlay.origin on copy up to use it later for these cases.
>> Store the lower filesystem uuid along side the file handle, so we can
>> validate that we are looking for the origin file in the original fs.
>>
>> On failure to encode lower file handle, store an invalid 'null' handle,
>> so we can always use the overlay.origin xattr to distinguish between
>> a copy up and a pure upper inode.
>>
>> If lower fs does not support NFS export ops or if not all layers are
>> on the same fs, don't try to encode a lower file handle and store the
>> 'null' handle instead.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
> [...]
>> @@ -316,6 +417,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>>         if (err)
>>                 goto out_cleanup;
>>
>> +       /*
>> +        * Store identifier of lower inode in upper inode xattr to
>> +        * allow lookup of the copy up origin inode.
>> +        */
>> +       err = ovl_set_origin(dentry, temp);
>
> calls setxattr - should be inside the temp->d_inode code block
>

No. it doesn't - sorry for the noise.
