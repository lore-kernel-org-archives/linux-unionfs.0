From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Wed, 17 Jun 2015 10:44:58 -0400
Message-ID: <558187EA.60805@tycho.nsa.gov>
References: <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk> <16652.1434490473@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <16652.1434490473@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/16/2015 05:34 PM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>> Why are you talking about file_open()?
> 
> Because that's the focus of the patch 5/7 that this comment chain is in
> response to.  You said that it should have a common helper with the dentry and
> inode init functions.

Ah, thanks - I had lost the context (the patch and prior discussion was
sufficiently long ago to drop out of my cache).

> 
> 	Also, would be good to create a common helper for use here, by
> 	selinux_dentry_init_security(), selinux_inode_init_security(), and
> 	may_create().  Already some seeming potential for inconsistencies
> 	there.
> 
> Okay, I missed that you'd said may_create() too.  I further assumed that you
> meant that selinux_file_open_union() should use the common helper too.

If it also needs to compute the context of a newly created file.  That's
what the logic in may_create, inode_init_security, and
dentry_init_security is doing.

>> Until a process writes to the file, we just want to use the lower inode
>> label, right?
> 
> No.
> 
> There are two issues:
> 
>  (1) Non-fd accesses to an overlayfs file use the security label on the
>      overlay inode, not the lower inode, even before copy up because they go
>      through the inode ops of the overlayfs file first.
> 
>  (2) I'm told that we want the ability to have a different label on the upper
>      file to that on the lower file.  This is trivial in overlayfs since you
>      always have an overlay inode off which to hang the security label, but
>      tricky with unionmount since you may only have a dentry.

I recall that being controversial.  I agree that if a process attempts
to write to the file and a copy-up is triggered, then we want to be able
to label the copy of the file differently.  But until that happens, why
wouldn't we simply treat the file as having the lower file label for
access control purposes on read operations?
