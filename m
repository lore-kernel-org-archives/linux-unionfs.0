From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/7] Security: Provide unioned file support
Date: Fri, 07 Nov 2014 15:21:24 +0000
Message-ID: <29936.1415373684@warthog.procyon.org.uk>
References: <545BC088.6080306@schaufler-ca.com> <545BB147.4000100@schaufler-ca.com> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <6108.1415296719@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaKGPVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 7 Nov 2014 10:21:36 -0500
In-Reply-To: <545BC088.6080306@schaufler-ca.com>
Content-ID: <29935.1415373684.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> >> What does this mean?
> > It has been decided that for the purposes of docker, all files within the
> > docker root fs will have the same label.  We'd have to provide policy
> > namespacing otherwise (I think).
> 
> That's just insane. "It has been decided" by who? Obviously not people
> who care about security policies. Maybe it's good enough for your
> particular use case, but labeling of files has to be up to the security
> module. That's what the modules are for.

It has been decided by the docker people that I've dealt with.  I was
expecting there to be different labels throughout a docker image, but
apparently not...

> >> What about LSMs that have multiple labels on a file?
> > Setting policy is something I'll have to leave to the docker people and the
> > administrators of systems that use docker.
> 
> What does that mean? If the underlying mechanism can't do the job,
> how the dickens is the administrator supposed to make it happen?

I'm trying to make the kernel able to support a policy on this at all - not
actually write the policy itself.  The policy may well vary depending on the
installation anyway.

> > But all I'm proposing is a way to give the LSM access to both the file in
> > the overlay and the file in the lower fs that is leeching through into the
> > overlay.
> 
> But your mechanisms are simultaneously incomplete and over specified.

Well then, specify better ones!  I'm fairly certain it is incomplete and I'm
*trying* to get input on how it may be improved.  I should've marked the
patches [RFC] but it didn't occur to me until just after I'd sent them (of
course).

Anyway, there are a number of things one has to take account of:

 (1) There may be multiple 'views' or instances of a file in a union - and
     each may be labelled differently.

 (2) The lower file may have xattrs attached to it that represent the security
     policy.

 (3) The union file may have xattrs attached to it that represent the security
     policy.

 (4) When copying the lower file up, the xattrs representing the security
     attributes of the lower file must not be written as they may incorrectly
     overwrite the security attributes of the union file.

 (5) There needs to be a way to set the security attributes on the union file.

 (6) When setting the attributes on the union file, the LSM might need to take
     account of the attributes of the lower file in their derivation.

 (7) There may be no inode in the union layer on which to hang the attributes
     for the upper file.

 (8) struct file::f_security should be used to contain the union layer
     labellage on open files that point to a lower layer.

 (9) Ideally, file->f_path would point to the union layer and file->f_inode to
     the lower layer when there is no upper file.  However, this is not the
     case at the moment.  The file struct *only* points to the lower file or
     the upper file and never both.

(10) Overlayfs has an extra complication in that there are potentially three
     files involved in any union.  The lower file that is the source, the
     upper file that where the copy-up goes and the virtual union file in the
     overlay fs that redirects to one or the other.

     I've taken the approach that we assume that the upper file (if it exists)
     has the same labellage as the union file.

> Your proposal is a cop out. It may work in a limited set of cases.
> It is not a general solution.

Actually, I think the actual code interface I've proposed is pretty close to
being a general solution.  I've given the LSM the information I have, it can
implement a fabulous maze of specially crafted labels if it wants to - and
even have multiple labels per inode or per file.  The VFS does not care.

David
