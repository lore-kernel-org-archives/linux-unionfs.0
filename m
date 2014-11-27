From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 27 Nov 2014 14:15:23 +0000
Message-ID: <12039.1417097723@warthog.procyon.org.uk>
References: <545B73DE.6090101@tycho.nsa.gov> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <11463.1415275413@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaK0OP3 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 27 Nov 2014 09:15:29 -0500
In-Reply-To: <545B73DE.6090101@tycho.nsa.gov>
Content-ID: <12038.1417097723.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > The third case is the tricky one because we have to try and derive a
> > label.  I've copied the code from the inode creation - so unless the
> > policy changes or the parent directory inode changes, I would've thought
> > we'd be okay.
> 
> Only if the filesystem ultimately calls security_inode_init_security()
> on the new inode.

I'm not sure what you mean?  What new inode?

The isec label derived by the code goes in the file struct, not the inode
struct because we can only get here if there isn't an inode struct.

David
