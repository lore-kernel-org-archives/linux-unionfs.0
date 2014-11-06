From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 06 Nov 2014 12:27:38 +0000
Message-ID: <31660.1415276858@warthog.procyon.org.uk>
References: <11463.1415275413@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <11463.1415275413@warthog.procyon.org.uk>
Content-ID: <31659.1415276858.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Good point.  I need to call avc_has_perm() directly.  I don't necessarily have
> an sclass, though, hmmm...

I do have an sclass on the lower file, however, as pointed to by
file_inode(file).

David
