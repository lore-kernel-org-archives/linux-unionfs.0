From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 08:16:29 -0400
Message-ID: <5582B69D.3010208@tycho.nsa.gov>
References: <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk> <8458.1434623534@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <8458.1434623534@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2015 06:32 AM, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
>> It is may_create() that has the duplicated logic
> 
> Not precisely.  may_create() doesn't use SECURITY_FS_USE_MNTPOINT and
> sbsec->mntpoint_sid.  Should it?

Yes, they should all use exactly the same logic.



