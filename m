From: Raphael Hertzog <raphael@ouaza.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by
 PostgreSQL
Date: Tue, 7 Nov 2017 13:59:45 +0100
Message-ID: <20171107125945.ctv2svep3k6m3ud5@home.ouaza.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
 <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
 <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:47617 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754880AbdKGM7s (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 07:59:48 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>

Hi,

Le mardi 07 novembre 2017, Amir Goldstein a écrit :
> > FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
> > Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (development
> > release).
> 
> And is this the same PostgreSQL version that worked with kernel v4.12.6?

No. Postgresql 10 became the default in Debian Testing on October 11th
and we switched to Linux 3.13.4 on October 9th, so at about the same
time...

And it seems likely that this fsync() call has been added as part of
PostgreSQL 10 in that commit:
https://git.postgresql.org/gitweb/?p=postgresql.git;a=commitdiff;h=1b02be21f271db6bd3cd43abb23fa596fcb6bac3

> Perhaps this a PostgreSQL regression (when storing db on overlayfs/squashfs)
> that should be reported to PostgreSQL developers?

I will do that in parallel but it seems awkward to have a writable
filesystem where fsync() is not working... I can understand the desire
to delegate to the underlying filesystem but that's one more case where we
might want to hide the fact that we have a read-only layer below.

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
