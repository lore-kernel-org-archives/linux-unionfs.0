From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] SELinux: Stub in copy-up handling
Date: Thu, 18 Jun 2015 17:51:15 +0100
Message-ID: <2213.1434646275@warthog.procyon.org.uk>
References: <5582D953.2030209@tycho.nsa.gov> <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133254.12722.33339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbbFRQvW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 12:51:22 -0400
In-Reply-To: <5582D953.2030209@tycho.nsa.gov>
Content-ID: <2212.1434646275.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, SELinux <selinux@tycho.nsa.gov>

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> I'm not sure we never want to copy up the SELinux attribute.  See my
> other email about ecryptfs and supporting per-file labeling and
> consistent access control over the upper and lower inodes.

Yes.  That's why there are two operations. inode_copy_up() should set the
label appropriately and inode_copy_up_xattr() should prevent the label set by
inode_copy_up() from being clobbered.

Note that inode_copy_up() has access to the lower file label and can perform
some sort of incantation to transmute it before applying it.

David
