From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unmounting lower filesystem while overlayfs uses it
Date: Thu, 10 Mar 2016 18:43:09 -0500
Message-ID: <20160310234309.GB8890@thunk.org>
References: <56E1CF7C.1010505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58292 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbcCJXnN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Mar 2016 18:43:13 -0500
Content-Disposition: inline
In-Reply-To: <56E1CF7C.1010505@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-unionfs@vger.kernel.org

On Thu, Mar 10, 2016 at 01:48:12PM -0600, Goldwyn Rodrigues wrote:
> Hi,
> 
> I noticed that you can continue using overlayfs while the underlying
> filesystem is unmounted. While overlayfs continues to use and show the
> entries from the underlying filesystem. Howerver, /proc/mounts is missing
> the lowerdir mount entry. This could be pretty confusing for users (say for
> example for users looking to hot swap devices)
> 
> I traced it down to the vfs mount point being copied/cloned as opposed to
> using the original one. Is there a reason why a new vfsmount is used as
> opposed to using the lowerdir's vfsmount? Perhaps I did not look hard
> enough, but I did not find any changes being made to the cloned lowerdir
> vfsmount.

There are all sorts of way that users can get confused about which
devices are mounted or not.  For example, if you are using mount
namespaces, just because it is unmounted in *your* namespace doesn't
mean that it isn't still mounted in some other processes's namespace.

I've had at least one bug report from a Debian user when some random
application program happened to use create its own mount namespace,
and then when the user unmounted the file system in the normal
(default) namespace, the file system was still mounted in the
namespace of this daemon, and the file system only got unmounted when
the daemon shut down (and released the namespace).

So this is a much bigger problem than just one that shows up in
unionfs or overlayfs.  It's similar to the issue where a program is
holding an open file descriptor on a large file, and the system
administrators gets confused space dossn't get reclaimed after he
deletes the file.  We don't currently have the equivalent of "lsof"
for mounts, but it should be possible to create such a thing.

					- Ted
					
