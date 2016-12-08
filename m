From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC][PATCH] ovl: overlayfs snapshots documentation
Date: Thu, 8 Dec 2016 11:35:09 +0200
Message-ID: <CAOQ4uxiLVu6M-7J=ZsgMUcRKaVU0uvxYcdWJxg4NPn3TihW=8A@mail.gmail.com>
References: <1481184043-30634-1-git-send-email-amir73il@gmail.com> <CAOQ4uxh+F2ZwHTM8BOB081hLZReSfB4TTL0nd6y+RWFs8yhUMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36625 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLHJfe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 04:35:34 -0500
Received: by mail-wj0-f193.google.com with SMTP id j10so26208328wjb.3
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Dec 2016 01:35:11 -0800 (PST)
In-Reply-To: <CAOQ4uxh+F2ZwHTM8BOB081hLZReSfB4TTL0nd6y+RWFs8yhUMw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Dec 8, 2016 at 10:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Dec 8, 2016 at 10:00 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Document the overlayfs snapshots feature.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  Documentation/filesystems/overlayfs-snapshots.txt | 197 ++++++++++++++++++++++
>>  1 file changed, 197 insertions(+)
>>  create mode 100644 Documentation/filesystems/overlayfs-snapshots.txt
>>
>> Hi all,
>>
>> I am posting this document in full to make it easier for those who
>> would like to comment inline, but it is also available for reading in pretty
>> formatting on wiki:
>> https://github.com/amir73il/overlayfs/wiki/Snapshots-overview
>>
>> This is actually v2, after already incorporating some typo fixes
>> from Neil Brown - Thanks!
>>
>
> And now echoing some more comments/questions from Neil for myself
> to address...
>

Neil,

I will do my best to answer your questions and attempt
to fix the documentation to address the unclear bits.

Thank you for your valuable feedback.
Amir.

>>
>>
>> diff --git a/Documentation/filesystems/overlayfs-snapshots.txt b/Documentation/filesystems/overlayfs-snapshots.txt
>> new file mode 100644
>> index 0000000..4d6025f
>> --- /dev/null
>> +++ b/Documentation/filesystems/overlayfs-snapshots.txt
>> @@ -0,0 +1,197 @@
>> +Written by: Amir Goldstein
>> +
>> +See Documentation/filesystems/overlayfs.txt for required background.
>> +
>> +Overlayfs Snapshots
>> +===================
>> +
>> +This document describes the overlayfs snapshots feature.
>> +
>> +Snapshot overlay
>> +----------------
>> +
>> +A 'snapshot overlay' may be thought of as a 'reverse overlay'.
>> +It looks exactly like a regular overlay mount with one 'lower' layer
>> +and one 'upper' layer, combined into a unified view, e.g.:
>> +
>> +  mount -t overlay snap0 -olowerdir=/lower,upperdir=/upper/0,\
>> +  workdir=/work /snap/0
>> +
>> +Although the mount looks the same and has similar characteristics to
>> +a regular overlay mount, it is used in a non conventional way for a
>> +different use case.
>> +
>> +With a regular overlay mount, the lower layer is expected to remain
>> +unchanged, while upper layer is modified to contain all changes
>> +performed on the union overlay mount.
>> +
>> +With a snapshot overlay mount, lower layer is allowed to change,
>> +while upper layer is modified to 'cover up' on these changes by
>> +creating copies of the original objects, before they are modified
>> +in the lower layer.
>> +
>> +The result is that the content of the snapshot overlay remains
>> +constant and therefore, can be used as a snapshot in time of the
>> +lower layer at the time that the snapshot overlay was mounted.
>> +
>> +As with regular overlay, the st_dev and st_ino fields of an
>> +object in the snapshot overlay may change during the life time
>> +of that object, but its content shall remain constant.
>> +
>> +
>> +Snapshot mount
>> +--------------
>> +
>> +The secret sauce that is responsible of 'covering up' before lower layer
>> +changes is the 'snapshot mount'. A 'snapshot mount', although similar by
>> +name, is not the same as a 'snapshot overlay'. In fact, it is not an
>> +overlay at all.
>> +
>> +The snapshot mount acts as a shim over the lower layer to intercept
>> +filesystem operations before modifying the lower layer objects and precede
>> +those operations with "copy up" to upper layer.
>> +
>> +A snapshot mount takes 2 mount options: 'snapshot=' and 'upperdir='.
>> +The 'snapshot=' mount option points to a snapshot overlay mount point.
>> +The 'upperdir=' mount option points to the lower dir of the snapshot overlay.
>> +For example:
>> +
>> +  mount -t snapshot current -oupperdir=/lower,snapshot=/snap/0 /lower
>> +
>> +In this example, the snapshot mount is mounted at /lower, on top of the
>> +underlying filesystem, so any future access to /lower directory will not go
>> +unnoticed.
>> +
>> +Notice that the file system type used for the snapshot mount is 'snapshot'
>> +and not 'overlay'. This distinction is merely a way to identify the role
>> +of the mount. Under the hood, the snapshot mount super block operations
>> +are somewhat different then the standard overlayfs super block operations,
>> +because they serve a different purpose.
>> +
>> +The most notably different operation is d_real().  Like, the standard
>> +overlayfs d_real() it will trigger copy up, before any change to an object.
>> +Unlike standard overlayfs d_real(), it always returns the same dentry
>> +is was given as input. So when an application opens a file in /lower it
>> +will really always get a direct handle to the file is lower.
>> +
>> +As a result, filesystem operations on the snapshot mount should not exhibit
>> +any of the overlayfs non standard behavior patterns.
>> +
>> +
>> +Underlying filesystem
>> +---------------------
>> +
>> +The upper and lower directories of a snapshot overlay must be on the
>> +same underlying filesystem.  The underlying filesystem must be supported
>> +for an overlay upper layer, so it must be writable and must be a local
>> +filesystem with extended attributes support.
>> +
>> +On top of these standard overlayfs requirements, the underlying filesystem
>> +must also support NFS export operations, so it could use the "redirect_fh"
>> +feature (see "Renaming directories" section).
>> +
>> +
>> +Readdir
>> +-------
>> +
>> +Readdir from a snapshot overlay is very similar to readdir from a regular
>> +overlay of single upper and single lower with one exception -
>> +lower directory may have been deleted, so whiteouts in an upper dir
>> +need to be hidden, also when there is no lower directory.
>
> neilb> The end of this sentence isn't clear.  I can probably work out what it
> neilb> means, but it wouldn't hurt to use a few more words to make it clear.
>

Readdir from a snapshot overlay is very similar to readdir from a regular
overlay of single upper and single lower with one exception - with snapshot
overlay, the lower directory may have been deleted.

With regular overlay, upper dir with no lower dir means this is a new 'pure'
upper directory, so readdir from overlay is a native readdir of the upper dir.

With snapshot overlay, upper dir with no lower means that upper was copied
from lower and then lower was deleted. In this case there may be residue
whiteouts in the upper directory, so readdir from overlay must hide them
like it does when reading a merged upper+lower directory.

>> +
>> +Readdir from the snapshot mount is a native readdir of the lower dir.
>> +
>> +
>> +Renaming directories
>> +--------------------
>> +
>> +When renaming a directory in the lower layer, snapshot mount can handle it
>> +in two different ways:
>> +
>> +1. return EXDEV error: this error is returned by rename(2) when trying to
>> +   move a file or directory across filesystem boundaries.  Hence
>> +   applications are usually prepared to handle this error (mv(1) for example
>> +   recursively copies the directory tree).  This is the default behavior.
>> +
>> +2. If the "redirect_fh" feature is enabled, then the file handle of the lower
>> +   directory will be stored in an extended attribute "trusted.overlay.fh" on
>> +   the copied up directory.  The file handle is then used to lookup the lower
>> +   directory when reading from the snapshot overlay.  This lookup method is
>> +   invariant to lower directory renames.
>> +
>> +
>> +Implicit opaque directory
>> +-------------------------
>> +
>> +With regular overlay, when a new directory is created in upper on top of
>> +a whited out object, that directory is marked as opaque to prevent merging
>> +it with lower directories of the same name.
>> +
>> +With snapshot overlay, a similar result is achieved implicitly from the
>> +"redirect_fh" feature. When a lower directory has been deleted and a new
>> +object of the same name created in its place, the file handle stored in
>> +the upper directory, that used to lookup the lower directory becomes stale.
>> +
>> +When the snapshot overlay lookup reaches a stale directory file handle, it
>> +treats it as if the upper directory is opaque to get the expected result
>> +of not exposing the new objects in lower in the snapshot overlay.
>> +
>
> neilb> It's not clear to me what happens if a directory is deleted from /lower.
> neilb> Is it copied up first, or does it disappear (e.g. become 'stale')?
>

One of the secret ingredients of the secret sauce is that write access to *any*
object in the file system is preceded by copy up to upper. This is not the same
as regular overlay, where for example, rmdir() would not copy up the removed
directory, but only its parents.

As a result, rmdir() in lower end up with a copied dir in upper and no
dir in lower,
which is the desired outcome. In all likelihood, though, the directory
is already in
upper before the rmdir(), because it had to be copied up to contain copied up
files on earlier unlink() calls in the snapshot mount.

Good luck to me incorporating this information in the doc. I'll probably end up
dumping this entire paragraph under ---Unlink and rmdir---


>> +
>> +Explicit whiteouts
>> +------------------
>> +
>> +In order to support create and mkdir in lower without the risk of those
>> +objects being exposed in the snapshot overlay, whiteouts need to be created
>> +in upper prior to creating objects in lower.
>> +
>> +Explicit whiteout is requested from the overlay mount by passing a
>> +negative dentry and non zero open flags to d_real().  d_real() is
>> +normally used to request a copy up of a file from lower to upper before
>> +opening the file for write.  Similarly, the new API means "copy nothing
>> +to upper before it changes to something".
>> +
>> +
>> +Multiple snapshots
>> +------------------
>> +
>> +An overlayfs mount may be stacked on top of another (lower) overlayfs
>> +mount, but only a single level of nesting is allowed. Together with
>> +the underlying filesystem at level 0, this amounts to the maximum allowed
>> +filesystem stack depth of 2.
>
> neilb> You say that overlays can stack to a depth of 2, but don't say *why*
> neilb> there is a limit.  I suspect the reason could be a bit complex, but some
> neilb> sort of pointer to it would help the curious.
>

include/linux/fs.h:#define FILESYSTEM_MAX_STACK_DEPTH 2

It is a VFS limit meant to protect against (kernel) stack overlflow of over
nested  "stackable filesystems". It is important to note that it is
the stackable
filesystems themselves (overlaytfs and ecryptfs) that are responsible
to enforce that limit (in fill_super).

>> +
>> +To get a view of anything but the latest snapshot overlay, a single
>> +overlayfs mount is stacked on top of the latest snapshot overlay and
>> +the historic upper layers are used as lower layers in reverse order,
>> +oldest upper layer on top. For example, to get a view at time 2 from
>> +the latest snapshot overlay at time 4:
>> +
>> +  mount -t overlay snap2 -olowerdir=/upper/2:/upper/3:/snap/4 /snap/2
>> +
>> +As the example shows, "upperdir=" and "workdir=" are omitted, so the
>> +stacked overlay mount is read-only.
>> +
>> +Similarly, we could mount more nested snapshot overlays to get a view
>> +of the lower dir at any other snapshot time, e.g.:
>> +
>> +  mount -t overlay snap3 -olowerdir=/upper/3:/snap/4 /snap/3
>> +
>> +NOTE, that all these mounts will become stale once /snap/4 is no
>> +longer the latest snapshot and they will have to be remounted with
>> +the new latest snapshot as the lowest layer in order to revalidate
>> +their content, e.g.:
>> +
>> +  mount -t overlay snap3 -olowerdir=/upper/3:/upper/4:/snap/5 /snap/3
>> +
>> +
>> +Testsuite
>> +---------
>> +
>> +There is a fork of the testsuite developed by David Howells, with support
>> +for testing overlayfs snapshots at:
>> +
>> +  https://github.com/amir73il/unionmount-testsuite.git
>> +
>> +Run as root:
>> +
>> +  # cd unionmount-testsuite
>> +  # ./run --sn
>> --
>> 2.7.4
>>
