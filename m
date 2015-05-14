From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] unionmount-testsuite: test rmdir of non-empty opaque dir
Date: Thu, 14 May 2015 11:46:43 +0100
Message-ID: <27824.1431600403@warthog.procyon.org.uk>
References: <CAN6Zp5xCn2GGxkBeOopy_7QaSjkq4XjEqbKn--4kbA-GzfP-Mg@mail.gmail.com> <20150513151502.GB19583@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbbENKqr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 May 2015 06:46:47 -0400
In-Reply-To: <CAN6Zp5xCn2GGxkBeOopy_7QaSjkq4XjEqbKn--4kbA-GzfP-Mg@mail.gmail.com>
Content-ID: <27823.1431600403.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vincent Batts <vbatts@gmail.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Josh Boyer <jwboyer@fedoraproject.org>, linux-unionfs@vger.kernel.org

Vincent Batts <vbatts@gmail.com> wrote:

> I'm not familiar with this testsuite. The empty_dir will be on the
> lower level, and all the rmdir, mkdir and create are happening on a
> mounted union fs? I don't see where that is clear.

That's handled by the core of the test infrastructure:

	http://git.infradead.org/users/dhowells/unionmount-testsuite.git

Look in the base of the git tree.

The infrastructure creates a load of files and other objects then sets up the
requested union (unionmount, overlayfs or even no union at all) over them and
then runs all the tests.

David
