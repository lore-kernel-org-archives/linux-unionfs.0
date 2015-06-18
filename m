From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 16:26:49 +0100
Message-ID: <18137.1434641209@warthog.procyon.org.uk>
References: <5582BE0F.5030703@tycho.nsa.gov> <558187EA.60805@tycho.nsa.gov> <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk> <16652.1434490473@warthog.procyon.org.uk> <8182.1434622539@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5582BE0F.5030703@tycho.nsa.gov>
Content-ID: <18136.1434641209.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, eparis@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Almost want to be able to compute a transition label for the ecryptfs
> inodes from the lower inode label so that it can be derived from but
> potentially different from the lower inode label.  That way policy could
> maintain per-file distinctions within an ecryptfs mount and distinguish
> between access to the encrypted vs plaintext representations.

Yeah.  What we want is something like:

  lower-inode-label + proposed-upper-label + subject-label -> inode-label

By proposed-upper-label I mean the default label for a new inode at that the
point in the directory tree at which the copy up will take place.

David
