From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 11:32:14 +0100
Message-ID: <8458.1434623534@warthog.procyon.org.uk>
References: <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55805AEA.3050407@tycho.nsa.gov>
Content-ID: <8457.1434623534.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> It is may_create() that has the duplicated logic

Not precisely.  may_create() doesn't use SECURITY_FS_USE_MNTPOINT and
sbsec->mntpoint_sid.  Should it?

David
