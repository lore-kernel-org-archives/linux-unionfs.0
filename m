From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 01/17] ovl: document NFS export
Date: Sat, 13 Jan 2018 10:54:58 +0200
Message-ID: <CAOQ4uxibP+3itm3XyUkiv3ekT+SHAcN=hoxC3b46_A+zAZB3Rg@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-2-git-send-email-amir73il@gmail.com> <CAJfpegtJBS1PFZGoiBeGL_LhT4b1=w5fHw462wzUNcVekzLB+g@mail.gmail.com>
 <CAOQ4uxhU5GDrE0MOnHWg+OaPUzp4GWaf0ryBzQHZ7fGsJGEqdg@mail.gmail.com>
 <CAJfpeguBEXP8wA-DHATQasEQJgMcX44U-JMoY21T1o-eYi7ftQ@mail.gmail.com> <CAJfpegs1FLcH8O+1ay+G6wK+VNX7UpOF+QwdC3eCDWDFr+CowQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34479 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeAMIzA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 13 Jan 2018 03:55:00 -0500
In-Reply-To: <CAJfpegs1FLcH8O+1ay+G6wK+VNX7UpOF+QwdC3eCDWDFr+CowQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 12, 2018 at 5:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jan 12, 2018 at 4:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jan 11, 2018 at 5:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>>> When decoding an upper dir, the decoded upper path is the same path as
>>> the overlay path, so we lookup same path in overlay.
>>>
>>> When decoding a lower dir from layer 1, every ancestor is either still lower
>>> (and therefore not renamed) or been copied up and indexed by lower inode,
>>> so we can use index to know the path of every ancestor in overlay (or if it
>>> has been removed).
>>>
>>> When decoding a lower dir from layer 2, there may be an ancestor in layer 2
>>> covered by whiteout in layer 1 and redirected from another directory in layer 1.
>>> In that case, we have no information in index to reconstruct the overlay path
>>> from the connected layer 2 directory, hence, we cannot decode a connected
>>> overlay directory from dir file handle encoded from layer 2.
>>
>> Now I understand: we are missing the back pointer from layer2 to
>> layer1 that the index provides us when going from lower to upper.
>>
>> However, this is only needed if we end up below a redirecting layer.
>> So we could limit copy-up to these cases.  It doesn't seem hard to
>> keep track of highest layer that had a redirect in each overlay
>> dentry, and when ending up on a layer below that, mark the overlay
>> dentry COPY_UP_FOR_ENCODE.  This information is constant, since lower
>> layers are immutable, so no worries there.  Can postpone this to a
>> later version, but the takeaway is that we need to mark the fh to
>> indicate if it's a merge upper or not.
>

I did not understand what you mean by marking to fh merge upper or not.
In any case, the idea is to mark the dentries like these as ENCODE_UPPER,
then not only they will be copied up on encode, but also *always* encoded as
upper for consistency.

> And BTW, we need to copy up only the directory that has the redirect,
> since that's where we are missing the mapping in the lower layers.
> Below that in the tree, we are fine, until we come across another
> redirect, and so on...
>

I think that is a somewhat simplified description of the situation.
Things can be more complicated, for example:

layer1: /a/b (/a has redirect to 'A')
layer2: /A/b/c/d
layer3: /A/b/c/d/e/f

When decoding the lower path /A/b/c/d, copy up of /a will index by
layer1 dir /a and doesn't help with backward redirect from layer2 dir /A.

Copy up of layer1 /a/b doesn't help either.

We must find the ancestor of /A/b/c/d which is an 'uppermost lower',
which is /A/b/c, and copy up/index that ancestor.

So I *think* we need to store in lookup per dentry:
- reconnect_layer_idx:
The highest layer with a non-indexed redirect (can be upper layer
in case of a non-indexed upper merge dir) among all ancestors.
If we encode a file handle from dir in reconnect_layer or above,
we can decode it and use decoded path to reconnect overlay dentry.
- OVL_ENCODE_UPPER
This is determined by combination of reconnect_layer_idx, the
uppermost lower layer of self and uppermost lower layer of parent.
I *think* the condition is:
lowerpath[0]->layer->idx > parent->lowerpath[0]->layer->idx &&
lowerpath[0]->layer->idx > reconnect_layer_idx

In the example above, dentries /a/b/c and /a/b/c/d/e are marked
OVL_ENCODE_UPPER. /a/b/c should be copied up when encoding
/a/b/c/d and /a/b/c/d/e should be copied up when encoding /a/b/c/d/e/f.
In reality, I assume nfsd always encodes /a/b/c on lookup of
/a/b/c/d before encoding /a/b/c/d, but to be on the safe side, we
need to take care of copy up of OVL_ENCODE_UPPER ancestor.


This is my re-take on Documentation of this wrinkle:

When overlay filesystem has multiple lower layers, a middle layer
directory may have a "redirect" to lower directory.  Because middle layer
"redirects" are not indexed, a lower file handle that was encoded from the
"redirect" origin directory, cannot be used to find the middle or upper
layer directory.  Similarly, a lower file handle that was encoded from a
descendant of the "redirect" origin directory, cannot be used to
reconstruct a connected overlay path.  To mitigate the cases of
directories that cannot be decoded from a lower file handle, these
directories are copied up on encode and encoded as an upper file handle.

Let me know what you think.

Thanks,
Amir.
