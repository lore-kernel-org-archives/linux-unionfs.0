From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/17] ovl: document NFS export
Date: Fri, 12 Jan 2018 16:49:17 +0100
Message-ID: <CAJfpegs1FLcH8O+1ay+G6wK+VNX7UpOF+QwdC3eCDWDFr+CowQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-2-git-send-email-amir73il@gmail.com> <CAJfpegtJBS1PFZGoiBeGL_LhT4b1=w5fHw462wzUNcVekzLB+g@mail.gmail.com>
 <CAOQ4uxhU5GDrE0MOnHWg+OaPUzp4GWaf0ryBzQHZ7fGsJGEqdg@mail.gmail.com> <CAJfpeguBEXP8wA-DHATQasEQJgMcX44U-JMoY21T1o-eYi7ftQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33976 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933994AbeALPtS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 10:49:18 -0500
Received: by mail-qk0-f178.google.com with SMTP id b76so9197003qkc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jan 2018 07:49:18 -0800 (PST)
In-Reply-To: <CAJfpeguBEXP8wA-DHATQasEQJgMcX44U-JMoY21T1o-eYi7ftQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 12, 2018 at 4:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 11, 2018 at 5:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>> When decoding an upper dir, the decoded upper path is the same path as
>> the overlay path, so we lookup same path in overlay.
>>
>> When decoding a lower dir from layer 1, every ancestor is either still lower
>> (and therefore not renamed) or been copied up and indexed by lower inode,
>> so we can use index to know the path of every ancestor in overlay (or if it
>> has been removed).
>>
>> When decoding a lower dir from layer 2, there may be an ancestor in layer 2
>> covered by whiteout in layer 1 and redirected from another directory in layer 1.
>> In that case, we have no information in index to reconstruct the overlay path
>> from the connected layer 2 directory, hence, we cannot decode a connected
>> overlay directory from dir file handle encoded from layer 2.
>
> Now I understand: we are missing the back pointer from layer2 to
> layer1 that the index provides us when going from lower to upper.
>
> However, this is only needed if we end up below a redirecting layer.
> So we could limit copy-up to these cases.  It doesn't seem hard to
> keep track of highest layer that had a redirect in each overlay
> dentry, and when ending up on a layer below that, mark the overlay
> dentry COPY_UP_FOR_ENCODE.  This information is constant, since lower
> layers are immutable, so no worries there.  Can postpone this to a
> later version, but the takeaway is that we need to mark the fh to
> indicate if it's a merge upper or not.

And BTW, we need to copy up only the directory that has the redirect,
since that's where we are missing the mapping in the lower layers.
Below that in the tree, we are fine, until we come across another
redirect, and so on...

Thanks,
Miklos
