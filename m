From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 27 Nov 2014 17:25:38 +0000
Message-ID: <16216.1417109138@warthog.procyon.org.uk>
References: <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <545A51CB.6070107@tycho.nsa.gov>
Content-ID: <16215.1417109138.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Also, would be good to create a common helper for use here, by
> selinux_dentry_init_security(), selinux_inode_init_security(), and
> may_create().  Already some seeming potential for inconsistencies there.

selinux_dentry_init_security() and selinux_inode_init_security() do something
different depending on SECURITY_FS_USE_MNTPOINT.  Is the dentry variant wrong?
Shouldn't it be using the mountpoint label if that flag _is_ set?

David
