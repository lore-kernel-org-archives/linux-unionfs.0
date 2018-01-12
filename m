From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/17] ovl: document NFS export
Date: Fri, 12 Jan 2018 16:43:21 +0100
Message-ID: <CAJfpeguBEXP8wA-DHATQasEQJgMcX44U-JMoY21T1o-eYi7ftQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-2-git-send-email-amir73il@gmail.com> <CAJfpegtJBS1PFZGoiBeGL_LhT4b1=w5fHw462wzUNcVekzLB+g@mail.gmail.com>
 <CAOQ4uxhU5GDrE0MOnHWg+OaPUzp4GWaf0ryBzQHZ7fGsJGEqdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35103 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933947AbeALPnW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 10:43:22 -0500
Received: by mail-qk0-f195.google.com with SMTP id w1so9163603qka.2
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jan 2018 07:43:22 -0800 (PST)
In-Reply-To: <CAOQ4uxhU5GDrE0MOnHWg+OaPUzp4GWaf0ryBzQHZ7fGsJGEqdg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 11, 2018 at 5:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jan 11, 2018 at 6:06 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  Documentation/filesystems/overlayfs.txt | 59 +++++++++++++++++++++++++++++++++
>>>  1 file changed, 59 insertions(+)
>>>
>>> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
>>> index 00e0595f3d7e..9e21c14c914c 100644
>>> --- a/Documentation/filesystems/overlayfs.txt
>>> +++ b/Documentation/filesystems/overlayfs.txt
>>> @@ -315,6 +315,65 @@ origin file handle that was stored at copy_up time.  If a found lower
>>>  directory does not match the stored origin, that directory will not be
>>>  merged with the upper directory.
>>>
>>> +
>>> +NFS export
>>> +----------
>>> +
>>> +When the underlying filesystems supports NFS export and the "verify"
>>> +feature is enabled, an overlay filesystem may be exported to NFS.
>>> +
>>> +With the "verify" feature, on copy_up of any lower object, an index
>>> +entry is created under the index directory.  The index entry name is the
>>> +hexadecimal representation of the copy up origin file handle.  For a
>>> +non-directory object, the index entry is a hard link to the upper inode.
>>> +For a directory object, the index entry has an extended attribute
>>> +"trusted.overlay.origin" with an encoded file handle of the upper
>>> +directory inode.
>>> +
>>> +When encoding a file handle from an overlay filesystem object, the
>>> +following rules apply:
>>> +
>>> +1. For a non-upper object, encode a lower file handle from lower inode
>>> +2. For an indexed object, encode a lower file handle from copy_up origin
>>> +3. For a pure-upper object and for an existing non-indexed upper object,
>>> +   encode an upper file handle from upper inode
>>> +
>>> +Encoding of a non-upper directory object is not supported when overlay
>>> +filesystem has multiple lower layers.  In this case, the directory will
>>> +be copied up first, and then encoded as an upper file handle.
>>
>> Why?
>>
>> What's the difference from encoding the uppermost lower layer directory?
>
> Sigh... hard to document... here goes an attempt.
> Let me know if it works:
>
> When decoding an upper dir, the decoded upper path is the same path as
> the overlay path, so we lookup same path in overlay.
>
> When decoding a lower dir from layer 1, every ancestor is either still lower
> (and therefore not renamed) or been copied up and indexed by lower inode,
> so we can use index to know the path of every ancestor in overlay (or if it
> has been removed).
>
> When decoding a lower dir from layer 2, there may be an ancestor in layer 2
> covered by whiteout in layer 1 and redirected from another directory in layer 1.
> In that case, we have no information in index to reconstruct the overlay path
> from the connected layer 2 directory, hence, we cannot decode a connected
> overlay directory from dir file handle encoded from layer 2.

Now I understand: we are missing the back pointer from layer2 to
layer1 that the index provides us when going from lower to upper.

However, this is only needed if we end up below a redirecting layer.
So we could limit copy-up to these cases.  It doesn't seem hard to
keep track of highest layer that had a redirect in each overlay
dentry, and when ending up on a layer below that, mark the overlay
dentry COPY_UP_FOR_ENCODE.  This information is constant, since lower
layers are immutable, so no worries there.  Can postpone this to a
later version, but the takeaway is that we need to mark the fh to
indicate if it's a merge upper or not.

Thanks,
Miklos
