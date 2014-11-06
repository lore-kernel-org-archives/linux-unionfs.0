From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 06 Nov 2014 13:34:28 +0000
Message-ID: <787.1415280868@warthog.procyon.org.uk>
References: <545B73DE.6090101@tycho.nsa.gov> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <11463.1415275413@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKFNeh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 6 Nov 2014 08:34:37 -0500
In-Reply-To: <545B73DE.6090101@tycho.nsa.gov>
Content-ID: <786.1415280868.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Not sure what filesystems you have in mind for the unionmount scenario.

Currently any filesystem that can be used for a unionmount top layer has to be
modified to provide certain things (DT_WHITEOUT and DT_FALLTHRU directory
entry creation) - and the way this is done precludes a number of filesystems
from being used (it modifies the on-disk format).

Whiteout creation is being provided by some filesystems for overlayfs - but in
a different way to unionmount (0,0 chardevs rather than DT_WHITEOUT dirents).

David
