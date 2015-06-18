From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode label [ver #2]
Date: Thu, 18 Jun 2015 19:23:28 +0100
Message-ID: <5947.1434651808@warthog.procyon.org.uk>
References: <5583007A.8040704@tycho.nsa.gov> <1509.1434645664@warthog.procyon.org.uk> <5582FB01.9080602@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5583007A.8040704@tycho.nsa.gov>
Content-ID: <5946.1434651808.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> >> +	rc = selinux_determine_inode_label(d_inode(dentry), name,
> > 
> > We want d_inode(dentry->d_parent) here.
> 
> Not sure why the caller didn't just pass in the dir inode in the first
> place.

Might be something in one of the other LSMs?

David
