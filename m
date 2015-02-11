From: David Howells <dhowells@redhat.com>
Subject: Re: Support for filesystems with d_revalidate (NFS)
Date: Wed, 11 Feb 2015 13:03:36 +0000
Message-ID: <22229.1423659816@warthog.procyon.org.uk>
References: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbbBKNDl (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 11 Feb 2015 08:03:41 -0500
In-Reply-To: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
Content-ID: <22228.1423659816.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Caldwell, Blake A." <blakec@ornl.gov>
Cc: dhowells@redhat.com, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Caldwell, Blake A. <blakec@ornl.gov> wrote:

> My use case for overlayfs is a NFS (v3 or v4) lowerdir, which appears
> rejected by the code below because NFS defines d_revalidate, d_automount,
> and d_weak_revalidate (v3 only).

How do you solve the file locking and fanotify problems?

David
