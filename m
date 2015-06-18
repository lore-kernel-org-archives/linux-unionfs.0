From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/8] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 16:04:19 +0100
Message-ID: <17087.1434639859@warthog.procyon.org.uk>
References: <5582DB99.70001@tycho.nsa.gov> <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133302.12722.14996.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5582DB99.70001@tycho.nsa.gov>
Content-ID: <17086.1434639859.1@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > +	/* We need to check that the union file is allowed to be opened as well
> > +	 * as checking that the lower file is allowed to be opened.
> 
> Hmm...so if I try to open a file for write access, then we are going to
> require that the process be allowed to write to both the union/overlay
> inode and to the lower inode?  That seems problematic for the containers
> use case where no write access will be granted to the lower files.

Actually, this comment should probably be deleted.  I am currently thinking
that access through the overlay fs should only be mediated by the label on the
overlay inode and should not involve the lower inode.

Possibly, then the lower file label should be reckoned against the label of
whoever created the *mount*.

David
