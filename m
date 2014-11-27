From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/7] SELinux: The copy-up operation must have read permission on the lower file
Date: Thu, 27 Nov 2014 14:17:36 +0000
Message-ID: <12076.1417097856@warthog.procyon.org.uk>
References: <545A6464.5070702@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154318.2555.7052.stgit@warthog.procyon.org.uk> <545A53A9.4060009@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <545A6464.5070702@tycho.nsa.gov>
Content-ID: <12075.1417097856.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> This means that it expects to trigger those capability checks as part of
> its subsequent actions.  Raising those capabilities temporarily in its
> credentials will pass the capability module checks but won't address the
> corresponding SELinux checks (both capability and file-based), so you'll
> end up triggering an entire set of checks against the current process'
> credentials.  This same pattern is repeated elsewhere in overlayfs.

Hmmm...  Yes.  I need to check whether the lower file can be read *before*
overriding the creds.

David
