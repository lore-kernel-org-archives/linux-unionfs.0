From: "Caldwell, Blake A." <blakec@ornl.gov>
Subject: Re: Support for filesystems with d_revalidate (NFS)
Date: Wed, 11 Feb 2015 20:29:37 +0000
Message-ID: <29470FC8-D05E-4C9C-B150-DB1CD3023294@ornl.gov>
References: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
 <22229.1423659816@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.177.12]:1298 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbbBKU3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 11 Feb 2015 15:29:40 -0500
In-Reply-To: <22229.1423659816@warthog.procyon.org.uk>
Content-Language: en-US
Content-ID: <46A10230DEE70F488DE50E969A3174B7@ornl.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Feb 11, 2015, at 6:03 AM, David Howells <dhowells@redhat.com<mailto:dhowells@redhat.com>> wrote:

Caldwell, Blake A. <blakec@ornl.gov<mailto:blakec@ornl.gov>> wrote:

My use case for overlayfs is a NFS (v3 or v4) lowerdir, which appears
rejected by the code below because NFS defines d_revalidate, d_automount,
and d_weak_revalidate (v3 only).

How do you solve the file locking and fanotify problems?
That's where I need your help :-)

You're lkml post was helpful for me to read
https://lkml.org/lkml/2015/1/26/740

NFS is a bit overkill for distributing a filesystem tree snapshot over the network, but it is an efficient way to do it. Pages are loaded into the page cache, meaning the whole image doesn't need to be transferred over the network. Coherent locking and *notify are complicating the matter, but I could see how supporting them is necessary to declare NFS support. I'm not sure what options exist for this use case, but it seems to be shared by several others.

To describe the desired behavior. When node1 opens a file R/O a local read lock is sufficient. It would prevent processes local to the system from opening an overlapping write lock. If another node, node2, opens the same file R/W it should attempt to take a lock that would conflict with the lock on node1. However, it will invoke copyup on node2 and maintain a write lock. Unintended copyups need to be blocked, or (as you mentioned without proper handling) the resulting copy may lose the lock.

This seems to point towards local only locks -o nlock, and trusting the cluster not to modify the filesystem (to also prevent fanotify). Given the lack of enforcement mechanisms on the client for latter, are we limited to removing that check by hand and compiling a custom kernel, or would an override "mount with possible inconsistency" option be merge-able?


