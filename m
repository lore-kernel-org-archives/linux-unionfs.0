From: David Howells <dhowells@redhat.com>
Subject: Overlayfs, *notify() and file locking...
Date: Mon, 26 Jan 2015 22:02:12 +0000
Message-ID: <22064.1422309732@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-ID: <22063.1422309732.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, eparis@redhat.com, jeff.layton@primarydata.com
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Having looked briefly at *notify() and file locking with an eye to doing some
changes there to provide support LSMs and procfs for overlayfs/unionmount type
things, I'm wondering how we're going to manage these two facilities.

The problem with both of these (afaict) is that they attach things to the
inode(s) to be watched.  Now, take overlayfs for an example:

Say you have a file that is pristine and on the lower layer.  You open it read
only and lock it.  Someone else then opens it for writing.  Even if there's a
mandatory lock on it, it will be copied up, and the copy will have no locks on
it.  Now, we can get round that - sort of - by duplicating, sharing or moving
the locking records between the inodes (though they may well exist on widely
different media).

This is probably manageable, provided there isn't one or more servers involved
(imagine if you've got one layer on NFS and another on CIFS, for example).
Further more, if there are leases, we have to manage those trans-copyup also.

Note that moving the lock may not be possible if the R/O file is still open
and still locked.  The R/O file still refers to the R/O copy, even after the
copy up.

The situation is slightly complicated in the case of overlayfs in that there's
a third inode - the overlay inode - around, though that's probably bypassed by
file->f_inode pointing to one of the other layers.  Note that to get proc and
LSMs working, I need to make file->f_path point to the overlay/union layer
whilst file->f_inode points to the upper/lower layer inode.

The situation is more complicated in the case of unionmount if we go there as
there *is* no top inode to hang things off until we try to write to the union
layer.

Two further complications are that if a lock is placed on a lower inode, that
lower inode may be shared with other overlays - and so must (a) be copied,
moved or duplicated to the right overlay; and (b) must still interact
correctly with any locks from other overlays.

Yet a further complication is how should locks interact between a file shared
between namespaces?  F_GETLK can return information about a locker
(eg. l_pid).

To summarise the problems:

 (1) Locks may need to migrate between layers on copy up.

 (2) Locks taken on source layers must still interact even after copy up.

 (3) The top layer may get in the way.

 (4) Layers may be remote and have remote locks (eg. NFS).

 (5) There are also leases.

 (6) There may be multiple overlays sharing files and locks must be copied up
     to the right place.

 (7) Mandatory locks vs copyup.

 (8) f_path needs to point to the overlay layer while f_inode points to the
     lower layer to fix proc and LSMs.


Now, the problem with file notifications is very similar.  These again hang
off the inode, but the inode they need to be hung off may change:

 (1) Watches may need to migrate between layers.

 (2) Watches on the source layer need to be duplicated to all overlays on copy
     up.

 (2b) Watches probably theoretically ought to remain watching the copied up
      files even after a restart.  This is probably just too impractical,
      though.

 (3) The top layer may get in the way and watches should probably go on the
     appropriate lower layer.

 (4) The layers may be remote and have remote watches (eg. CIFS).

 (5) f_path needs to point to the overlay layer while f_inode points to the
     lower layer to fix proc and LSMs.


Note that for both overlayfs and unionmount, directories are 'real' on the top
layer, so watches (and locks if that's possible) may be easier to handle
there, though in another sense, they're harder since they're the union of
several directories' worth of contents and *all* the contributory directories
need to be watched as two unions need not be fabricated from the same set of
directories in the same order.

David
