From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode label [ver #3]
Date: Mon, 22 Jun 2015 10:41:47 +0100
Message-ID: <9305.1434966107@warthog.procyon.org.uk>
References: <9833421.4OAA7AQtgN@sifl> <6033.1434651905@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbbFVJlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:41:52 -0400
In-Reply-To: <9833421.4OAA7AQtgN@sifl>
Content-ID: <9304.1434966107.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>

Paul Moore <paul@paul-moore.com> wrote:

> This patch looks fine to me and I think there is an advantage to merging this 
> regardless of what happens with the "unioning" work so I'm inclined to queue 
> this up now unless you would prefer to resubmit with the union patches?

If you could queue it up now, that'd be great!

David
