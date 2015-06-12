From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Fri, 12 Jun 2015 16:30:54 +0100
Message-ID: <8813.1434123054@warthog.procyon.org.uk>
References: <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <16216.1417109138@warthog.procyon.org.uk>
Content-ID: <8812.1434123054.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Stephen,

David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Also, would be good to create a common helper for use here, by
> > selinux_dentry_init_security(), selinux_inode_init_security(), and
> > may_create().  Already some seeming potential for inconsistencies there.
> 
> selinux_dentry_init_security() and selinux_inode_init_security() do
> something different depending on SECURITY_FS_USE_MNTPOINT.  Is the dentry
> variant wrong?  Shouldn't it be using the mountpoint label if that flag _is_
> set?

Any answer to that?

David
