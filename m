From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode label
Date: Thu, 18 Jun 2015 17:39:01 +0100
Message-ID: <22821.1434645541@warthog.procyon.org.uk>
References: <5582F307.6030005@tycho.nsa.gov> <22037.1434644340@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5582F307.6030005@tycho.nsa.gov>
Content-ID: <22820.1434645541.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	rc = selinux_determine_inode_label(d_inode(dentry), name,
> 
> Hmmm...previously we were using d_backing_inode(dentry->d_parent) here.

You're right.  In changing between various sorts of dentry and inode I've lost
one of the subtleties.

David
