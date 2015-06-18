From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode label
Date: Thu, 18 Jun 2015 17:42:20 +0100
Message-ID: <1605.1434645740@warthog.procyon.org.uk>
References: <5582F307.6030005@tycho.nsa.gov> <22037.1434644340@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5582F307.6030005@tycho.nsa.gov>
Content-ID: <1604.1434645740.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	rc = selinux_determine_inode_label(d_inode(dentry), name,
> 
> Hmmm...previously we were using d_backing_inode(dentry->d_parent) here.

I also think this should probably be d_inode() not d_backing_inode() since
we're being called by the filesystem that owns the dentry being contemplated.

David
