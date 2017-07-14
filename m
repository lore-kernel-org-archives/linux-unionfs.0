From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Fri, 14 Jul 2017 10:42:13 +0300
Message-ID: <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34263 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGNHmO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 03:42:14 -0400
Received: by mail-yb0-f193.google.com with SMTP id n205so4626312yba.1
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 00:42:14 -0700 (PDT)
In-Reply-To: <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 13, 2017 at 11:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> When inodes index feature is enabled, if lower dir does not match the
>> origin fh stored in upper dir, or if no lower dir was found by name,
>> try to decode the stored origin fh and use the result as the merge dir
>> lower dentry.
>>
>> This change is needed for indexing of merge directories. A merge
>> directory is indexed by the file handle of the uppermost lower dir and
>> the index will have a reference to the upper dir by file handle.
>> Following down from upper by origin file handle ensures the integrity
>> of the index for non-stale origin entries. index entries with stale origin
>> are going to be cleaned up on mount anyway.
>
> Not sure I understand.  In what case is following down by origin needed?
>

First, a snip from cover letter, parts of it may belong in this commit message:

-------->8-------->8-------->8-------->8-------->8-------->8-------->8-------->8

Specifically, patches 9-10 introduce a behavior change in the
case of changes to lower layer (rename or delete of lower dir).
The new behavior is to verify origin fh and try to decode it
if verification fails (overlayfs.txt updated).

This change in needed for snapshots and I argue in the commit
message of patch 10 why it is needed for indexing of directories.
I admit that the argument is not rigorous, but since the behavior of
changes to lower layer is documented as "undefined", I recon you
don't really mind if we change it for index=on.

The rational of making this change in v4.13 as opposed to when
directory indexing is implemented, is that index=on already introduces
a behavior change related to copying layers, so IMO it is better to
introduce all those behavior changes together on index=on.

-------->8-------->8-------->8-------->8-------->8-------->8-------->8-------->8

My main argument is that 10/10 is needed for snapshots along with patch
9/10 and assuming that you don't object to the change of behavior in 9/10,
then perhaps you are ambivalent to this change as well (apparently not).

My secondary NFS export related argument goes something like this.

<more hand waving, but while writing stuff on the board>
An indexed merge dir would look something like:

lower/dir[encode_fh] = 0001
upper/dir[encode_fh] = 0002
upper/dir[origin] = 0001
index/0001[upper] = 0002
overlay/dir[encode_fh] = 0001

When encoding the overlay/dir we get a file handle of 0001.
When decoding overlay handle 0001, we find an index that points
to upper that points to origin 0001, so all is sane.

Now, if lower/dir is renamed to dir2 and a new dir is created in its place
we get:

lower/dir[encode_fh] = 0003
lower/dir2[encode_fh] = 0001
upper/dir[encode_fh] = 0002
upper/dir[origin] = 0001
index/0001[upper_fh] = 0002
overlay/dir[encode_fh] = ???

Now when we encode overlay/dir we either get 0003 (current kernel)
or 0002 (patch 9/10) or 0001 (patch 10/10).
decoding 0002 will get us the pure upper dir not merged with the new
lower/dir which is consistent with what you get in lookup (path 9/10).

However! if NFS client has the file handle 0001, from before lower/dir
was renamed, then decoding that file handle, will get the same object as
when decoding 0002 and that same object will not be re-decoded to
0001, which is another inconsistency.

So yes, this certainly qualifies for "If the underlying filesystem is changed,
the behavior of the overlay is undefined...", but can if you agree that the
cost of patch 10/10 is not high, then it makes the entire
lookup/encode/decode flow file handle verified and then we can work with
stronger assumptions on overlay NFS handles.

</more hand waving>

Feeling any more at ease with this argument?

Amir.
