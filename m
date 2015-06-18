From: David Howells <dhowells@redhat.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Thu, 18 Jun 2015 14:39:08 +0100
Message-ID: <13405.1434634748@warthog.procyon.org.uk>
References: <5582C6C1.8080602@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbbFRNjL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 09:39:11 -0400
In-Reply-To: <5582C6C1.8080602@samsung.com>
Content-ID: <13404.1434634747.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org

Jan Olszak <j.olszak@samsung.com> wrote:

> I was wondering about a small improvement to overlayfs - optional, per file
> copy of write.
> 
> 1. By default overlayfs would work as usual.
> 2. If a file in 'lower' filesystem has an xattr set
> (e.g. trusted.overlay.cow=n) the file would not be copied.
> 
> What do you think?

Ummm.  What's the use case?  How do you handle the file being part of multiple
overlays?

David
